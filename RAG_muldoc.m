import matlab.net.*
import matlab.net.http.*
% Step 1: Read multiple files to construct the knowledge base
knowledgeBase = '';  % Initialize the knowledge base
addMoreFiles = true;
while addMoreFiles
    % Prompt user to input the file path
    filePath = input('Please enter the file path (txt;pdf;xlsx;docx): ','s');
    % Get the file extension
    [~, ~, ext] = fileparts(filePath);
    
    % Read file content based on the extension
     try
        if strcmp(ext, '.txt')
            % For text files
            fileContent = fileread(filePath);
            disp('Text file has been successfully read.');
            
        elseif strcmp(ext, '.pdf')
            % For PDF files
            fileContent = extractFileText(filePath);  % MATLAB's extractFileText() for PDFs
            disp('PDF file has been successfully read.');
            
        elseif strcmp(ext, '.docx')
            % For Word documents (.docx)
            fileContent = extractFileText(filePath);  % MATLAB's extractFileText() also supports .docx
            disp('Word document has been successfully read.');
            
        elseif strcmp(ext, '.xlsx')
            % For Excel files (.xlsx)
            [~, txtData, rawData] = xlsread(filePath);  % Use xlsread to read Excel content
            % Combine Excel text data into a single string
            fileContent = strcat(txtData{:});  % Concatenate all text cells into one string
            disp('Excel file has been successfully read.');
            
        else
            error('Unsupported file type. Only .txt, .pdf, .docx, and .xlsx files are allowed.');
        end
        
        % Add the file content to the knowledge base
        knowledgeBase = strcat(knowledgeBase, '\n', fileContent);
        
    catch
        error('Unable to read the file. Please check the file path.');
    end
    
    % Ask the user if they want to add more files to the knowledge base
    userChoice = input('Do you want to add another file to the knowledge base? (yes/no): ','s');
    if strcmpi(userChoice, 'no')
        addMoreFiles = false;
    end
end

disp('Knowledge base has been successfully constructed.');

% Step 2: Loop to ask multiple questions about the knowledge base
keepAsking = true;

while keepAsking
    % User asks a question
    userQuestion = input('You (type "exit" to stop)?: ','s');
    
    % If the user inputs 'exit', exit the question loop
    if strcmpi(userQuestion, 'exit')
        disp('Exiting the question loop.');
        break;
    end
    
    % Step 3: Generate the LLM prompt by combining the knowledge base and the user question
    prompt = sprintf('Knowledge base content: %s\nUser question: %s', knowledgeBase, userQuestion);
    
    % Prepare the message to be sent to the API
    messages = [struct('role', "system", 'content', "You are a helpful assistant."), ...
                struct('role', "user", 'content', prompt)];
    
    apiurl = "https://api.openai.com/v1/chat/completions";
    
    % API key (ensure that your OpenAI API key is set correctly)
    apikey = "Your OpenAI API key";  % Replace with your actual OpenAI API key
    
    % Build the request payload
    querymsg = struct('model', "gpt-4o", ...
                      'messages', messages, ...
                      'max_tokens', 2000, ...  % Adjust max tokens as needed
                      'temperature', 0.75);
    
    % Set HTTP headers
    headers = HeaderField('Content-Type', 'application/json', ...
                          'Authorization', "Bearer " + apikey);
    
    % Send the request
    request = RequestMessage('post', headers, querymsg);
    response = send(request, URI(apiurl));
    
    % Step 4: Parse and display the API response
    if response.StatusCode == "OK"
        responseText = response.Body.Data.choices(1).message.content;
        responseText = strtrim(responseText);
        disp(['HealthcareLLM: ', responseText]);
    else
        responseText = "Error "; 
        responseText = responseText + response.StatusCode + newline; 
        responseText = responseText + response.StatusLine.ReasonPhrase; 
        disp(responseText);
    end
end

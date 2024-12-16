import matlab.net.*
import matlab.net.http.*

% Step 1: Read file content (user inputs file path once)
filePath = input('Please enter the file path (e.g., C:\\example.txt or C:\\example.pdf): ','s');

% Check file extension
[~, ~, ext] = fileparts(filePath);

% Read the file content based on its extension
try
    if strcmp(ext, '.txt')
        % For text files
        fileContent = fileread(filePath);
        disp('Text file has been successfully read.');
    elseif strcmp(ext, '.pdf')
        % For PDF files, you may need a PDF reader
        fileContent = extractFileText(filePath);  % MATLAB's extractFileText() for PDFs
        disp('PDF file has been successfully read.');
    else
        error('Unsupported file type. Only .txt and .pdf files are allowed.');
    end
catch
    error('Unable to read the file. Please check the file path.');
end

% Step 2: Loop to ask multiple questions without re-entering file path
keepAsking = true;

while keepAsking
    % User asks a question about the file content
    userQuestion = input('What would you like to ask about the file (type "exit" to stop)?: ','s');
    
    % Check if the user wants to stop asking questions
    if strcmpi(userQuestion, 'exit')
        disp('Exiting the question loop.');
        break;
    end
    
    % Step 3: Combine the file content and the user question into a prompt for the LLM
    prompt = sprintf('File content: %s\nUser question: %s', fileContent, userQuestion);
    
    % Prepare messages
    messages = [struct('role', "system", 'content', "You are a helpful assistant."), ...
                struct('role', "user", 'content', prompt)];
    
    apiurl = "https://api.openai.com/v1/chat/completions";
    
    % API key (use direct string)
    apikey ="Your OpenAI API key";  % Make sure your API key is set in the environment variable
    
    % Define the request message
    querymsg = struct('model', "gpt-4o", ...
                  'messages', messages, ...
                  'max_tokens', 2000, ...  % Increase max tokens to handle larger responses
                  'temperature', 0.75);
    % Set the headers
    headers = HeaderField('Content-Type', 'application/json', ...
                          'Authorization', "Bearer " + apikey);
    
    % Create and send the request
    request = RequestMessage('post', headers, querymsg);
    response = send(request, URI(apiurl));
    
    % Step 4: Check and display the response
    % if response.StatusCode == "OK"
    %     responseText = response.Body.Data.choices(1).message.content;
    %     disp(['chatgpt: ', strtrim(responseText)]);
    % else
    %     disp(['Error ', response.StatusCode, ': ', response.StatusLine.ReasonPhrase]);
    % end
    if response.StatusCode == "OK" %判断是否获取回答成功
        responseText = response.Body.Data.choices(1).message; %从响应体中获取第一个选择项的消息内容，并将其赋值给变量 responseText
        responseText = string(responseText.content); %将 responseText 转换为字符串类型
        responseText = strtrim(responseText); %移除wrapped_s开头和结尾的空格和换行符
        str=['chatgpt: ',num2str(responseText)];
        disp(str) %在命令窗口显示回答
    else
        responseText = "Error "; %将字符串 "Error " 赋值给变量 responseText
        responseText = responseText + response.StatusCode + newline; %将响应状态码和一个换行符添加到 responseText 的结尾
        responseText = responseText + response.StatusLine.ReasonPhrase; %将响应状态行的原因短语添加到 responseText 的结尾
        disp(responseText) %在命令窗口显示回答
    end
end

% 消息获取处理并显示





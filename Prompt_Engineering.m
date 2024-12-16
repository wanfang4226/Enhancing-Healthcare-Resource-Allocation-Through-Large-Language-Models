
%% 提问文本输入
import matlab.net.*
import matlab.net.http.*
% Initialize the chat history (to store previous messages)
chatHistory = [];
% Define the API endpoint and API key
apiurl   = "https://api.openai.com/v1/chat/completions";  % OpenAI API endpoint
apikey   = "Your OpenAI API key";  % Replace with your actual OpenAI API key
% Main loop to handle multiple questions
while true
    % Prompt the user to input a question
    userQuestion = input('You(type "exit" to stop):', 's');    
    % Check if the user wants to exit the loop
    if strcmpi(userQuestion, 'exit')
        disp('Ending conversation.');
        break;
    end   

    % Append the user's message to the chat history
    chatHistory = [chatHistory; struct('role', "user", 'content', userQuestion)];  

    % Prepare the message to be sent to the API, including the entire chat history
    messages = [struct('role', "system", 'content', "You are a helpful assistant.")];
    messages = [messages; chatHistory];  % Include the chat history with each request 

    % Define the API request body
    querymsg = struct('model', "gpt-4o",'messages', messages,'max_tokens', 2000,'temperature', 0.75); 

    % Define the request headers
    headers = HeaderField('Content-Type', 'application/json','Authorization', "Bearer " + apikey);    

    % Create and send the API request
    request  = RequestMessage('post', headers, querymsg);
    response = send(request, URI(apiurl));  
    
    % Process the API response
    if response.StatusCode == "OK"
        % Get the assistant's reply
        assistantReply = response.Body.Data.choices(1).message.content;        
        % Append the assistant's reply to the chat history
        chatHistory = [chatHistory; struct('role', "assistant", 'content', assistantReply)];        
        % Display the assistant's reply
        disp(['HealthcareLLM: ', assistantReply]);
    else
        % Handle error response
        disp(['Error: ', response.StatusCode, ' - ', response.StatusLine.ReasonPhrase]);
    end
end

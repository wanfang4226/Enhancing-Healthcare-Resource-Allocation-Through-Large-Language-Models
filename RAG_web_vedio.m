import matlab.net.*
import matlab.net.http.*

% Step 1: Ask the user to choose between reading a webpage or a video
inputChoice = input('Choose input type (webpage: 1, video: 2): ', 's');

if strcmp(inputChoice, '1')
    % Reading webpage content
    url = input('Enter the webpage URL: ', 's');

    try
        webpageContent = webread(url);  % Read webpage content
        disp('Webpage content successfully retrieved.');
        %disp(webpageContent);  % Display the HTML content of the webpage (for simplicity)
    catch exception
        disp('Error reading webpage content:');
        disp(exception.message);
    end

    % Step 2: Ask a question about the webpage content
    userQuestion = input('You: ', 's');

    % Step 3: Prepare prompt for GPT
    prompt = sprintf('Webpage content: %s\nUser question: %s', webpageContent, userQuestion);

elseif strcmp(inputChoice, '2')%%%% C:/Users/123/Desktop/meeting_01.mp4
    % Download or use a local video file (download externally)
    videoFile = input('Enter the path to the video file: ', 's');  % Path to the downloaded video

    try
        vidObj = VideoReader(videoFile);  % Initialize VideoReader object
        disp(['Video Duration: ', num2str(vidObj.Duration), ' seconds']);
        disp(['Frame Rate: ', num2str(vidObj.FrameRate), ' frames per second']);

        % Example: Extracting a single frame
        frame = readFrame(vidObj);
        imshow(frame);  % Display the frame
        disp('Video file processed successfully.');

        % Step 2: Ask a question about the video content
        userQuestion = input('You: ', 's');

        % Prepare a simple description of the video to form a prompt
        videoDescription = sprintf('The video has a duration of %.2f seconds and a frame rate of %.2f fps.', ...
            vidObj.Duration, vidObj.FrameRate);

        % Step 3: Prepare prompt for GPT
        prompt = sprintf('Video details: %s\nUser question: %s', videoDescription, userQuestion);

    catch exception
        disp('Error reading video file:');
        disp(exception.message);
    end
else
    disp('Invalid choice. Please restart and choose 1 for webpage or 2 for video.');
end

% Step 4: Prepare to send the prompt to GPT
if exist('prompt', 'var')  % Only proceed if prompt is properly created

    % Prepare messages
    messages = [struct('role', "system", 'content', "You are a helpful assistant."), ...
                struct('role', "user", 'content', prompt)];

    apiurl = "https://api.openai.com/v1/chat/completions";

    % API key (use direct string)
    apikey ="Your OpenAI API key";  % Make sure your API key is set in the environment variable
    querymsg = struct('model', "gpt-4o", ...
                  'messages', messages, ...
                  'max_tokens', 2000, ...  % Increase max tokens to handle larger responses
                  'temperature', 0.75);
    % Set the headers
    headers = HeaderField('Content-Type', 'application/json', ...
                          'Authorization', "Bearer " + apikey);

    % Create and send the request
    request = RequestMessage('post', headers, querymsg);

    % Send the request and handle response
    try
        response = send(request, URI(apiurl));

        % Step 5: Check and display the response
        if response.StatusCode == matlab.net.http.StatusCode.OK
            responseText = response.Body.Data.choices(1).message.content;
            disp(['HealthcareLLM: ', strtrim(responseText)]);
        else
            disp(['Error ', char(response.StatusCode), ': ', response.StatusLine.ReasonPhrase]);
        end
    catch exception
        disp('Error sending request:');
        disp(exception.message);
    end
end

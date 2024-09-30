<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI에게 질문하기</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.5.1/styles/default.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        #questionForm {
            margin-bottom: 20px;
        }
        #question {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
        }
        #submitButton {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        #response {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            background-color: #f9f9f9;
        }
        pre code {
            background-color: #f4f4f4;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
        }
    </style>
</head>
<body>
    <h1>AI에게 질문하기</h1>
    <form id="questionForm">
        <input type="text" id="question" name="question" placeholder="질문을 입력하세요..." required>
        <button type="submit" id="submitButton">질문하기</button>
    </form>
    
    <div id="response"></div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/4.0.2/marked.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.5.1/highlight.min.js"></script>
    <script>
        $(document).ready(function() {
            marked.setOptions({
                breaks: true,
                gfm: true,
                highlight: function(code, lang) {
                    const language = hljs.getLanguage(lang) ? lang : 'plaintext';
                    return hljs.highlight(code, { language }).value;
                },
                langPrefix: 'hljs language-'
            });

            $('#questionForm').submit(function(e) {
                e.preventDefault();
                var question = $('#question').val();
                
                $.ajax({
                    url: 'http://localhost:9090/ai',
                    method: 'GET',
                    data: { message: question },
                    dataType: 'json',
                    success: function(response) {
                        if (response && response.completion) {
                            var htmlContent = marked.parse(response.completion);
                            $('#response').html(htmlContent);
                            hljs.highlightAll();
                        } else {
                            $('#response').html('<p>응답이 없습니다.</p>');
                        }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('AJAX 오류:', textStatus, errorThrown);
                        alert('오류가 발생했습니다. 다시 시도해 주세요.');
                    }
                });
            });
        });
    </script>
</body>
</html>

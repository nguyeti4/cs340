const questionTemplate = $("#question-template").html(); // this is a <tr> element
const $questions = $("#question-table");   // this is the <tbody> element
// const $ques = $("#add-question");   // this is the <tbody> element

console.log(questionTemplate);
console.log($questions);

// first load the page
$(document).ready( function(){
    console.log("document ready");
    $.ajax({
        type: "GET",
        url: "/api/questions",
        success: function(res, status, xhr) {
            $.each(res, function (index, question) {
                $questions.append(Mustache.render(questionTemplate, question));
            });
        },
    })
});

// add/update/delete users
$(function() {
    console.log('function')
    $("#add-question").on("click", function(e) {
        console.log('add-question clicked')
        
        var right_answer
        if ($('#right-answer').val()=="choice1") {
            right_answer = $('#choice-1').val();
        };
        if ($('#right-answer').val()=="choice2") {
            right_answer = $('#choice-2').val();
        };
        if ($('#right-answer').val()=="choice3") {
            right_answer = $('#choice-3').val();
        };
        

        var questionInfo = {
            state: $('#state').val(),
            question_desc: $('#question-desc').val(),
            right_answer: right_answer,
            choice_1: $('#choice-1').val(),
            choice_2: $('#choice-2').val(),
            choice_3:$('#choice-3').val()
        };
        $.ajax( {
            type: "POST",
            url: "/api/questions",
            data: questionInfo,
            success: function(res, status, xhr) {
                console.log(res);
                if (res.error) {
                    console.log(res.error);
                    $("#error-message").text(res.error);
                } else {
                    $questions.append(Mustache.render(questionTemplate, res));
                    $("#error-message").text("");
                };
            },
            error: function() {
                alert("error loading new question")
            }
        });
        $('#question-desc').val("");
        $('#choice-1').val("");
        $('#choice-2').val("");
        $('#choice-3').val("");
        $('#state')[0].selectedIndex = 0;
        $('#right-answer')[0].selectedIndex = 0;
        e.preventDefault();
    });

    $questions.delegate("#delete-question", "click", function(e) {
        console.log('delete-question clicked')
        e.preventDefault();
        var $deleteRow = $(this).closest("tr");
        console.log($(this).attr("question_id"));
        $.ajax( {
            type: "DELETE",
            url: "/api/questions/" + $(this).attr("question_id"),
            success: function() {
                $deleteRow.fadeOut(300, function(){
                    $(this).remove();
                });   
            },   
        });
    });

    $questions.delegate("#edit-question", "click", function(e) {
        console.log('edit-question clicked')
        e.preventDefault();
        var $editRow = $(this).closest("tr");
        console.log($editRow.find("span.name").html());
        $editRow.find("input.state").val($editRow.find("span.state").html());
        $editRow.find("input.question_desc").val($editRow.find("span.question_desc").html());
        $editRow.find("input.right_answer").val($editRow.find("span.right_answer").html());
        $editRow.find("input.choice_1").val($editRow.find("span.choice_1").html());
        $editRow.find("input.choice_2").val($editRow.find("span.choice_2").html());
        $editRow.find("input.choice_3").val($editRow.find("span.choice_3").html());
        $editRow.addClass("edit");
    });

    $questions.delegate("#cancel-edit-question", "click", function(e) {
        console.log('cancel-edit-question clicked')
        e.preventDefault();
        var $editRow = $(this).closest("tr");
        console.log($editRow.find("span.name").html());
        $editRow.removeClass("edit");
    });

    $questions.delegate("#save-edit-question", "click", function(e) {
        console.log('save-edit-question clicked')
        console.log($(this).attr("question_id"));
        var $updateRow = $(this).closest("tr");
        e.preventDefault();
        var quesInfo = {
            state: $updateRow.find("input.state").val(),
            question_desc: $updateRow.find("input.question_desc").val(),
            right_answer: $updateRow.find("input.right_answer").val(),
            choice_1: $updateRow.find("input.choice_1").val(),
            choice_2: $updateRow.find("input.choice_2").val(),
            choice_3: $updateRow.find("input.choice_3").val()
        };

        $.ajax( {
            type: "PUT",
            url: "/api/questions/" + $(this).attr("question_id"),
            data: quesInfo,
            success: function(res, status, xhr) {
                console.log(res);
                $updateRow.find("span.state").text(res.state);
                $updateRow.find("span.question_desc").text(res.question_desc);
                $updateRow.find("span.right_answer").text(res.right_answer);
                $updateRow.find("span.choice_1").text(res.choice_1);
                $updateRow.find("span.choice_2").text(res.choice_2);
                $updateRow.find("span.choice_3").text(res.choice_3);
                $updateRow.removeClass("edit");  
            },
            error: function() {
                alert("error updating question")
            }    
        });
    });
})




const quizQuestionTemplate = $("#quiz-question-template").html(); // this is a <tr> element
const $quizQuestions = $("#quiz-question-table");   // this is the <tbody> element

// first load the page
$(document).ready( function(){
    console.log("document ready");
    $.ajax({
        type: "GET",
        url: "/api/quiz_questions",
        success: function(res, status, xhr) {
            $.each(res, function (index, item) {
                $quizQuestions.append(Mustache.render(quizQuestionTemplate, item));
            });
        },
    })
});

// add/update/delete users
$(function() {
    console.log('function')
    $("#add-quiz-question").on("click", function(e) {
        console.log('add-quiz-question clicked')
        e.preventDefault();
        var itemInfo = {
            quiz_id: $('#quiz_id').val(),
            question_id: $('#question_id').val(),
            result: $('#result').val()
        };
        $.ajax( {
            type: "POST",
            url: "/api/quiz_questions",
            data: itemInfo,
            success: function(res, status, xhr) {
                console.log(res);
                if (res.error) {
                    console.log(res.error);
                    $("#error-message").text(res.error);
                } else {
                    $quizQuestions.append(Mustache.render(quizQuestionTemplate, res));
                    $("#error-message").text("");
                };  
            },
            error: function() {
                alert("error loading new record");
            }
        });
        $('#quiz_id')[0].selectedIndex = 0;
        $('#question_id')[0].selectedIndex = 0;
        $('#result')[0].selectedIndex = 0;
    });

    $quizQuestions.delegate("#delete-this", "click", function(e) {
        console.log('delete-this clicked')
        e.preventDefault();
        var $deleteRow = $(this).closest("tr");
        console.log($(this).attr("itemid"));
        $.ajax( {
            type: "DELETE",
            url: "/api/quiz_questions/" + $(this).attr("itemid"),
            success: function() {
                $deleteRow.fadeOut(300, function(){
                    $(this).remove();
                });   
            },   
        });
    });

    $quizQuestions.delegate("#edit-this", "click", function(e) {
        console.log('edit-this clicked')
        e.preventDefault();
        var $editRow = $(this).closest("tr");
        $editRow.find("select.result").val($editRow.find("span.reslut").html());
        $editRow.addClass("edit");
    });

    $quizQuestions.delegate("#cancel-edit-this", "click", function(e) {
        console.log('cancel-edit-this clicked')
        e.preventDefault();
        var $editRow = $(this).closest("tr");
        console.log($editRow.find("span.result").html());
        $editRow.removeClass("edit");
    });

    $quizQuestions.delegate("#save-edit-this", "click", function(e) {
        console.log('save-edit-this clicked')
        console.log($(this).attr("itemid"));
        var $updateRow = $(this).closest("tr");
        e.preventDefault();
        var itemInfo = {
            result: $updateRow.find("select.result").val(),
        };

        $.ajax( {
            type: "PUT",
            url: "/api/quiz_questions/" + $(this).attr("itemid"),
            data: itemInfo,
            success: function(res, status, xhr) {
                console.log(res);
                $updateRow.find("span.result").text(res.result);
                $updateRow.removeClass("edit");  
            },
            error: function() {
                alert("error updating this item")
            }    
        });
    });
})




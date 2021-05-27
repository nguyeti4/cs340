const userTemplate = $("#user-template").html(); // this is a <tr> element
const $users = $("#user-table");   // this is the <tbody> element
const $account = $("#add-account");   // this is the <tbody> element

console.log(userTemplate);
console.log($users);

// first load the page
$(document).ready( function(){
    console.log("document ready");
    $.ajax({
        type: "GET",
        url: "/api/users",
        success: function(res, status, xhr) {
            $.each(res, function (index, user) {
                $users.append(Mustache.render(userTemplate, user));
            });
        },
    })
});

// add/update/delete users
$(function() {
    console.log('function')
    $("#add-user").on("click", function(e) {
        console.log('add-user clicked')
        e.preventDefault();
        var userInfo = {
            user_name: $('#user_name').val(),
            user_password: $('#user_password').val(),
            user_email: $('#user_email').val(),
            regis_date: $('#regis_date').val(),
            active: $('#active').val()
        };
        $.ajax( {
            type: "POST",
            url: "/api/users",
            data: userInfo,
            success: function(res, status, xhr) {
                console.log(res);
                $users.append(Mustache.render(userTemplate, res));
            },
            error: function() {
                alert("error loading new users")
            }
        });

    });

    $users.delegate("#delete-user", "click", function(e) {
        console.log('delete-user clicked')
        e.preventDefault();
        var $deleteRow = $(this).closest("tr");
        console.log($(this).attr("user_id"));
        $.ajax( {
            type: "DELETE",
            url: "/api/users/" + $(this).attr("user_id"),
            success: function() {
                $deleteRow.fadeOut(300, function(){
                    $(this).remove();
                });   
            },   
        });
    });

    $users.delegate("#edit-user", "click", function(e) {
        console.log('edit-user clicked')
        e.preventDefault();
        var $editRow = $(this).closest("tr");
        console.log($editRow.find("span.name").html());
        $editRow.find("input.name").val($editRow.find("span.name").html());
        $editRow.find("input.password").val($editRow.find("span.password").html());
        $editRow.find("input.email").val($editRow.find("span.email").html());
        $editRow.find("input.regis").val($editRow.find("span.regis").html());
        $editRow.find("select.active").val($editRow.find("span.active").html());
        $editRow.addClass("edit");
    });

    $users.delegate("#cancel-edit-user", "click", function(e) {
        console.log('cancel-edit-user clicked')
        e.preventDefault();
        var $editRow = $(this).closest("tr");
        console.log($editRow.find("span.name").html());
        $editRow.removeClass("edit");
    });

    $users.delegate("#save-edit-user", "click", function(e) {
        console.log('save-edit-user clicked')
        console.log($(this).attr("user_id"));
        var $updateRow = $(this).closest("tr");
        e.preventDefault();
        var userInfo = {
            user_name: $updateRow.find("input.name").val(),
            user_password: $updateRow.find("input.password").val(),
            user_email: $updateRow.find("input.email").val(),
            regis_date: $updateRow.find("input.regis").val(),
            active: $updateRow.find("select.active").val(),
        };

        $.ajax( {
            type: "PUT",
            url: "/api/users/" + $(this).attr("user_id"),
            data: userInfo,
            success: function(res, status, xhr) {
                console.log(res);
                $updateRow.find("span.name").text(res.user_name);
                $updateRow.find("span.password").text(res.user_password);
                $updateRow.find("span.email").text(res.user_email);
                $updateRow.find("span.regis").text(res.regis_date);
                $updateRow.find("span.active").text(res.active);
                $updateRow.removeClass("edit");  
            },
            error: function() {
                alert("error updating users")
            }    
        });
    });
})




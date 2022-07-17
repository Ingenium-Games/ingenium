/*

*/
let Key = null
let Slots = null
let Characters = null
let Character_ID = null

function OnJoin(data) {
    if (data !== null) {
        $.each(data, function (index, value) {
            let cc = index + 1
            if (cc <= Slots) {
                $("#Row").prepend('<a id="' + value.Character_ID + '" class="Character tooltip" onclick="Selected(' + index + ')"><img src="'+value.Photo+'"/><span class="tooltiptext">' + value.First_Name + ' ' + value.Last_Name + '</span></a>');
            };            
            if (cc == Slots ) { 
                $("#New").remove();
                return false;
            };
        });
    };
};

function Selected(key) {
    if (key === "New") {
        $("#Play").show()
        $("#Kill").hide()
        Character_ID = "New"
        document.getElementById("name").innerText = "New Character"
        document.getElementById("created").innerText = "Click the tick"
        document.getElementById("lastseen").innerText = "Click the tick"
        document.getElementById("city").innerText = "Click the tick"
        document.getElementById("phone").innerText = "Click the tick"
    } else {
        $("#Play").show()
        $("#Kill").show()
        Character_ID = Characters[key].Character_ID
        Key = Characters[key]
        let Created = Characters[key].Created
        let First = Characters[key].First_Name
        let Last = Characters[key].Last_Name
        let Login = Characters[key].Last_Seen
        let Phone = Characters[key].Phone
        let City = Characters[key].City_ID
        document.getElementById("name").innerText = First + " " + Last;
        document.getElementById("created").innerText = new Date(Created).toLocaleDateString('en-AU')
        document.getElementById("lastseen").innerText = new Date(Login).toLocaleDateString('en-AU')
        document.getElementById("city").innerText = City
        document.getElementById("phone").innerText = Phone
    }
};

function CharacterDelete() {
    if (Character_ID !== null) {
        $.post("https://ig.core/Client:Character:Delete", JSON.stringify({
            ID: Character_ID,
        }));
    };
};

function CharacterJoin() {
    if (Character_ID !== null) {
        $.post("https://ig.core/Client:Character:Join", JSON.stringify({
            ID: Character_ID,
        }));
        $("#Sidebar").remove();
        $("#CharacterList").remove();
    };
};

function CharacterMake() {
    // Prevent form from submitting 
    var fn = document.getElementById("FirstName").value;
    var ln = document.getElementById("LastName").value;
    var cm = document.getElementById("Height").value;
    var dob = document.getElementById("DateOfBirth").value;
    $.post("https://ig.core/Client:Character:Register", JSON.stringify({
        First_Name: fn,
        Last_Name: ln,
        Height: cm,
        Birth_Date: dob,
    }));
    $("#CharacterMake").remove();
};

$(document).ready(function () {
    window.onload = (e) => {
        $("#DateOfBirth").mask("00-00-0000", { clearIfNotMatch: true });
        $("#Height").mask("000", { clearIfNotMatch: true });
        $("#CharacterMake").submit((e) => {
            if (e.defaultPrevented) {
                return; // Do nothing if the event was already processed
            }
            e.preventDefault();
        }).validate({
            rules: {
                FirstName: {
                    minlength: 1,
                    maxlength: 35,
                    required: true
                },
                LastName: {
                    minlength: 1,
                    maxlength: 35,
                    required: true
                },
                Height: {
                    minlength: 3,
                    maxlength: 3,
                    required: true
                },
                DateOfBirth: {
                    minlength: 10,
                    maxlength: 10,
                    required: true
                }
            },
            submitHandler: function (form) {
                form.submit();
                CharacterMake();
            }
        });

        window.addEventListener("message", (e) => {
            if (e.defaultPrevented) {
                return; // Do nothing if the event was already processed
            }
            let message = e.data.message
            let data = e.data.data;
            switch (message) {
                case "Joining":
                    Characters = data.Characters;
                    Slots = data.Slots;
                    $("#Sidebar").show();
                    $("#CharacterList").show();
                    OnJoin(Characters);
                    break;
                case "Register":
                    $("#CharacterMake").show();
                    break;
                case "default":
                    break;
            }
            e.preventDefault();
        });
    };
});
({
    doInit : function(component, event, helper) {
        var action = component.get("c.getContacts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    selectContact : function(component, event, helper) {
        var selectedContacts = component.get("v.selectedContacts") || [];
        console.log('selectedContacts >>>>> ',selectedContacts);
        var contactId = event.target.dataset.id;
        if (event.target.checked) {
            selectedContacts.push(contactId);
            console.log('selectedContacts >>>>> ',selectedContacts);
        } else {
            selectedContacts = selectedContacts.filter(function(id) {
                return id !== contactId;
            });
        }
        component.set("v.selectedContacts", selectedContacts);
        console.log('selectedContacts >>>>> ',selectedContacts);
    },
    
    sendEmail : function(component, event, helper) {
        var selectedContacts = component.get("v.selectedContacts");
        if (selectedContacts && selectedContacts.length > 0) {
            helper.sendEmail(component, selectedContacts, function(response) {
                if (response === "SUCCESS") {
                    alert("Email sent successfully.");
                } else {
                    alert("Error sending email: " + response);
                }
            });
        } else {
            alert("Please select at least one contact to send the email to.");
        }
    }
})
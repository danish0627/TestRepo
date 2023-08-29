({
    sendEmail : function(component, selectedContacts, callback) {
        var action = component.get("c.sendEmailToContacts");
        action.setParams({
            "contactIds": selectedContacts
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                callback("SUCCESS");
            } else {
                callback(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})
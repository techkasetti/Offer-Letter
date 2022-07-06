({
    /*
     * @Description: - Create a Map and put all the inputtype 
     * : - with attribute and then use this map while creating the fieldsets.
     * Available inputs for "lightning:input" are below
     * checkbox, date, datetime, email, file, password, search, tel, url, number, radio, and toggle
     */
    configMap: {
        "string": {
            componentDef: "lightning:input",
            attributes: {
                "class": "slds-input container",
            }
        },
        "checkbox": {
            componentDef: "lightning:input",
            attributes: {
                "class": "slds-checkbox__label"
            }
        },
        "button": {
            componentDef: "lightning:button",
            attributes: {
                "variant": "brand",
                "iconName": "utility:automate",
                "label": "Click to Search"
            }
        },
        "picklist": {
            componentDef: "ui:inputSelect",
            attributes: {
                "class": "slds-select slds-select_container container"
            }
        },
        "multipicklist": {
            componentDef: "lightning:dualListbox",
            attributes: {
                "sourceLabel": "Available Options",
                "selectedLabe": "Selected Options",
                "readonly": false
            }
        },
        "textarea": {
            componentDef: "lightning:textarea",
            attributes: {
                "class": "slds-input container"
            }
        },
    },
    onInit: function (component, event, helper) {
        var action = component.get("c.getsObjects");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')) {
                var sObjectList = response.getReturnValue();
                var listOptions = [];
                listOptions.push({
                    label: '--Select One--',
                    value: ''
                });
                for (var i = 0; i < sObjectList.length; i++) {
                    listOptions.push({
                        label: sObjectList[i].split('####')[1],
                        value: sObjectList[i].split('####')[0]
                    });
                }
                component.set('v.sObjectList', listOptions);
            } else if (state === 'INCOMPLETE') {
                console.log('User is Offline System does not support drafts '
                    + JSON.stringify(response.getError()));
            } else if (state === 'ERROR') {

            } else {

            }
        });
        //action.setStorable();
        $A.enqueueAction(action);

    },
    onSelectChange: function (component, event, helper) {

        // var selectedObject = component.find('selectObject').get('v.value');
        //alert('selectedObject>>'+selectedObject);
        component.set("v.theForm", []);
        var getFieldSet = component.get('c.getFieldSet');
        getFieldSet.setParams({
            "sObjectName": 'Candidate_Profile__c'
        });
        getFieldSet.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')) {
                var fieldsSetList = response.getReturnValue();
                var listOptions = [];
                /* listOptions.push({
                    label : '--Select One--',
                    value : ''
                });*/
                for (var i = 0; i < fieldsSetList.length; i++) {
                    listOptions.push({
                        label: fieldsSetList[i].split('####')[1],
                        value: fieldsSetList[i].split('####')[0]
                    });
                }
                component.set('v.fieldSetList', listOptions);
            } else if (state === 'INCOMPLETE') {
                console.log('User is Offline System does not support drafts '
                    + JSON.stringify(response.getError()));
            } else if (state === 'ERROR') {

            } else {

            }
        });
        //getFieldSet.setStorable();
        $A.enqueueAction(getFieldSet);
    },
    onFieldSetChange: function (component, event, helper, fieldSetmemberList1) {
        var self = this;
        // alert('fieldSetmemberList1 >>>>>>>>>'+JSON.stringify(fieldSetmemberList1));

        // var selectedObject = component.find('selectObject').get('v.value');
        // var selectedfieldSet = component.find('fieldSet').get('v.value');
        component.set('v.fieldSetmemberList1', fieldSetmemberList1);
        var FiledSetMember = component.get('c.getFieldSetMemberClone');
        FiledSetMember.setParams({
            "fieldSetName": JSON.stringify(component.get('v.fieldSetmemberList1'))
        });
        FiledSetMember.setCallback(this, function (response) {
            var state = response.getState();
            //alert('state >>>>>'+state);
            if (component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')) {

                var fieldSetMember = JSON.parse(response.getReturnValue());
                console.log('fieldSetMember>>' + JSON.stringify(fieldSetMember.FSName));
                self.createForm(component, event, helper, fieldSetMember.membertList);
            } else if (state === 'INCOMPLETE') {
                console.log('User is Offline System does not support drafts '
                    + JSON.stringify(response.getError()));
            } else if (state === 'ERROR') {
                console.log(response.getError());
            } else {

            }
        });
        //FiledSetMember.setStorable();
        $A.enqueueAction(FiledSetMember);
    },
    createForm: function (component, event, helper, fieldSetMember) {
        //  alert('createFormfieldSetMember>>'+JSON.stringify(fieldSetMember));
        // Create a map with availale inputs and according to this use the global map.
        var lightningInputMap = new Map();
        lightningInputMap.set('string', 'string');
        lightningInputMap.set('checkbox', 'checkbox');
        lightningInputMap.set('date', 'date');
        lightningInputMap.set('datetime', 'datetime');
        lightningInputMap.set('email', 'email');
        lightningInputMap.set('file', 'file');
        lightningInputMap.set('password', 'password');
        lightningInputMap.set('search', 'search');
        lightningInputMap.set('tel', 'tel');
        lightningInputMap.set('url', 'url');
        lightningInputMap.set('number', 'number');
        lightningInputMap.set('radio', 'radio');

        // list of components to create and put into the component body..
        var inputDesc = [];
        var config = null;

        /*
         * parse the FieldSet members and then create the members dynamically 
         * and put those components into the component.
         */
        for (var i = 0; i < fieldSetMember.length; i++) {
            //alert('fieldSetMember[i]>>'+fieldSetMember[i].fieldLabel);
            var objectName = component.getReference("v.sObjectName");
            if (lightningInputMap.has(fieldSetMember[i].fieldType.toLowerCase())) {
                config = JSON.parse(
                    JSON.stringify(this.configMap['string'])
                );
                if (config) {
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.type = fieldSetMember[i].fieldType;
                    config.attributes.required =
                        fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value =
                        component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                }
            } else {
                if (fieldSetMember[i].fieldType.toLowerCase() === 'integer') {
                    config = JSON.parse(
                        JSON.stringify(this.configMap['string'])
                    );
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.type = 'number';
                    config.attributes.required =
                        fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value =
                        component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                } else if (fieldSetMember[i].fieldType.toLowerCase() === 'phone') {
                    config = JSON.parse(
                        JSON.stringify(this.configMap['string'])
                    );
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.type = 'tel';
                    config.attributes.required =
                        fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value =
                        component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);

                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                } else if (fieldSetMember[i].fieldType.toLowerCase() === 'textarea') {
                    config = JSON.parse(
                        JSON.stringify(this.configMap['textarea'])
                    );
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.name = fieldSetMember[i].fieldLabel;

                    config.attributes.required =
                        fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value =
                        component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);

                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                } else if (fieldSetMember[i].fieldType.toLowerCase() === 'picklist') {
                    config = JSON.parse(
                        JSON.stringify(this.configMap['picklist'])
                    );
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.name = fieldSetMember[i].fieldLabel;
                    var pickList = fieldSetMember[i].pickListValues;
                    var options = [];
                    for (var k = 0; k < pickList.length; k++) {
                        if (pickList[k].active) {
                            options.push({
                                value: pickList[k].value,
                                label: pickList[k].label
                            });
                        }
                    }
                    config.attributes.options = options;
                    config.attributes.required =
                        fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value =
                        component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);

                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);
                } else if (fieldSetMember[i].fieldType.toLowerCase() === 'multipicklist') {
                    config = JSON.parse(
                        JSON.stringify(this.configMap['multipicklist'])
                    );
                    config.attributes.label = fieldSetMember[i].fieldLabel;
                    config.attributes.name = fieldSetMember[i].fieldLabel;
                    var pickList = fieldSetMember[i].pickListValues;
                    var options = [];
                    for (var k = 0; k < pickList.length; k++) {
                        if (pickList[k].active) {
                            options.push({
                                value: pickList[k].value,
                                label: pickList[k].label
                            });
                        }
                    }
                    config.attributes.options = options;
                    config.attributes.required =
                        fieldSetMember[i].isRequired || fieldSetMember[i].isDBRequired;
                    config.attributes.value =
                        component.getReference('v.sObjectName.' + fieldSetMember[i].fieldAPIName);
                    /*
                    inputDesc.push([
                        config.componentDef,
                        config.attributes
                    ]);*/
                }
            }
        }
        /* var newConfig = JSON.parse(
             JSON.stringify(this.configMap['button'])
         );
         newConfig.attributes.onclick = component.getReference("c.handlePress");
         inputDesc.push([
             newConfig.componentDef,
             newConfig.attributes
         ]);*/

        $A.createComponents(inputDesc,
            function (components, status, errorMessage) {
                if (status === "SUCCESS") {
                    var form = [];
                    for (var j = 0; j < components.length; j++) {
                        form.push(components[j]);
                        //alert('form>>'+form);
                    }
                    console.log('form>>' + form);
                    component.set("v.theForm", form);
                    console.log('v.theForm>>' + JSON.stringify(component.get("v.theForm")));
                } else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.");
                } else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    console.log(errorMessage);
                }
            }
        );
    },
    onUpserObject: function (component, event, helper, getSkillList) {
        var upsertObject = component.get('c.doUpsertObjects');
        alert('getSkillList>>' + getSkillList);
        alert('helper object>>' + JSON.stringify(component.get('v.sObjectName')));
        upsertObject.setParams({
            "objectData": JSON.stringify(component.get('v.sObjectName')),
            "skillList": getSkillList
        });
        upsertObject.setCallback(this, function (response) {
            var state = response.getState();
            alert('onUpserObjectSTATE>>' + state);
            if (state === 'SUCCESS') {
                alert('Return Value >>>>>>>>' + response.getReturnValue());
                //var upsertedRecord = JSON.parse(response.getReturnValue());
                component.set('v.candidateProfile', response.getReturnValue());
                alert('candidateProfile>>>>>>>>' + Component.get('v.candidateProfile'));
                //alert('upsertedRecord>>'+upsertedRecord);
            } else if (state === 'INCOMPLETE') {
                console.log('User is Offline System does not support drafts '
                    + JSON.stringify(response.getError()));
            } else if (state === 'ERROR') {
                console.log(response.getError());
            } else {
                console.log('Unknown Error While making DML'
                    + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(upsertObject);
    },
    getSkillSets: function (component, event, helper, selectedDeparment) {
        var action = component.get('c.getSkillSets');
        action.setParams({
            "selectedDeparment": selectedDeparment
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            // alert('Status >>'+state);
            if (state === 'SUCCESS') {
                var fieldsSetList = response.getReturnValue();
                var listOptions = [];
                for (var i = 0; i < fieldsSetList.length; i++) {
                    listOptions.push({
                        label: fieldsSetList[i],
                        value: fieldsSetList[i]
                    });
                }
                component.set('v.options', listOptions);
            } else if (state === 'ERROR') {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);

    },
    getDepartmentTypes: function (component, event, helper) {
        var action = component.get('c.getSkillSetsDepartment');
        action.setCallback(this, function (response) {
            var state = response.getState();
            // alert('Department Status >>'+state);
            if (state === 'SUCCESS') {
                var departmentList = response.getReturnValue();
                // alert('departmentList    >>>>>>'+departmentList);
                var listOptions = [];
                component.set('v.departmentpicklist', departmentList);
            } else if (state === 'ERROR') {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);

    },
    validateAccountRecords: function (component, event) {
        //Validate all account records
        var isValid = true;
        var accountList = component.get("v.accountList");
        for (var i = 0; i < accountList.length; i++) {
            if (accountList[i].Name == '') {
                isValid = false;
                alert('Account Name cannot be blank on ' + (i + 1) + ' row number');
            }
        }
        return isValid;
    },
    toggleAction: function (component, event, secId) {
        var acc = component.find(secId);
        for (var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');
            $A.util.toggleClass(acc[cmp], 'slds-hide');
        }
    }
})
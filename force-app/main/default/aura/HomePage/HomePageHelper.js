({
	setFilterbyCompanyList: function (component, event, helper) {
		// alert('Inside Helper');
		var action = component.get("c.getClientList");
		// action.setParams({});

		action.setCallback(this, function (response) {


			var state = response.getState();
			// alert(state) + 'Successme';
			if (state === "SUCCESS") {
				var clientList = response.getReturnValue();
				console.log('###############');
				var options = [];
				for (const key in clientList) {
					if (Object.hasOwnProperty.call(clientList, key)) {
						const element = clientList[key];
						options.push({ value: key, label: element });
					}
				}
				console.log(options);
				component.set('v.clientOptions', options);
			}
		});
		$A.enqueueAction(action);
	},

	setFilterbyStatusList: function (component, event, helper) {
		// alert('Inside Helper');
		var action = component.get("c.getStatusList");
		// action.setParams({});

		action.setCallback(this, function (response) {
			var state = response.getState();
			// alert(state) + 'Successme';
			if (state === "SUCCESS") {
				var clientList = response.getReturnValue();
				console.log('###############Status');
				var options = [];
				for (const key in clientList) {
					if (Object.hasOwnProperty.call(clientList, key)) {
						const element = clientList[key];
						options.push({ value: element, label: element });
					}
				}
				console.log(options);
				component.set('v.statusOptions', options);
			}
		});
		$A.enqueueAction(action);
	},

	getRecords: function (component, event, helper) {
		var companyFilter = component.get("v.selectedClient");
		var postStatus = component.get("v.selectedStatus");
		//var action = component.get("c.getJobPosting");
		var action = component.get("c.togetJobPostings");
		console.log(companyFilter + '' + postStatus);
		action.setParams({
			companyFilter: companyFilter,
			postStatus: postStatus,
            buttonType:'',
            buttonTypeId:'',
		});

		action.setCallback(this, function (response) {

			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();
			var clientList = [];
			// alert(state);
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				console.log('storeResponse ::: ' + storeResponse);
				var array = [];
				var storeResponseList = [];
				storeResponseList = JSON.stringify(storeResponse);
				console.log('storeResponseList ::: ' + storeResponseList);
				component.set("v.jobPostings", storeResponse);
                var jobPostingName = component.get("v.jobPostings");
				console.log(jobPostingName);
                /*component.set("v.jobApplications", storeResponseList);
                var jobApplicationName = component.get("v.jobApplications");
                console.log(jobApplicationName);*/
			}
			else {
				alert('there is no record to display');
			}
		});
		$A.enqueueAction(action);
	}
});
#ENABLE LOCALCLIENTCODE
#BEGIN CLIENTCODE
#BEGIN JAVASCRIPT

(() => {
	const aInterfaceUtils = {};
	let libraryBuilt = false;
	const engineWaitId = setInterval(() => {
		if (VS.World.global && !libraryBuilt) {
			// Since the client is not available inside of this function, we assign data to the type `Client` and when it is created, it uses that data.
			buildInterfaceUtils(aInterfaceUtils);
			libraryBuilt = true;
		}

		if (VS.Client && libraryBuilt) {
			clearInterval(engineWaitId);
			buildDialog(aInterfaceUtils);
		}
	});

	const buildDialog = (aInterfaceUtils) => {
		const MAX_PLANE = 1999998;
		VS.Client.aInterfaceUtils = aInterfaceUtils;
		// attach onMouseClick event to client
		if (!aInterfaceUtils.onMouseClickSet) {
			aInterfaceUtils._onMouseClick = VS.Client.onMouseClick;
			aInterfaceUtils.onMouseClickSet = true;
			VS.Client.onMouseClick = function(pDiob, pX, pY, pButton) {
				if (this.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu').shown) {
					if (pButton === 1) {
						if (!pDiob || pDiob.baseType !== 'Interface') {
							this.aInterfaceUtils.inInput = false;
							/* this.setMacroAtlas(this.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu').storedMacroAtlas); */
							this.setFocus();
						}
					}
				}
				if (this.aInterfaceUtils._onMouseClick) {
					this.aInterfaceUtils._onMouseClick.apply(this, arguments);
				}
			}
		}

		// toggle the debug mode, which allows descriptive text to be shown when things of notice happen
		aInterfaceUtils.toggleDebug = function() {
			this.debugging = (this.debugging ? false : true);
		}
/* 		
		VS.Macro.newMacroAtlas('aInterfaceUtils_alert_macro');
		VS.Macro.newMacroAtlas('aInterfaceUtils_input_macro');
		VS.Macro.newMacroAtlas('aInterfaceUtils_confirm_macro');

		// alert
		VS.Client.addCommand('closeAlertMenu', function() {
			this.aInterfaceUtils.closeAlertMenu();
		});
		VS.Client.addCommand('leftArrowSelectAlert', function() {

		});
		VS.Client.addCommand('rightArrowSelectAlert', rightArrowSelectAlert = function() {
			
		});
		// input
		VS.Client.addCommand('closeInputMenu', function() {
			this.aInterfaceUtils.closeInputMenu();
		});
		VS.Client.addCommand('leftArrowSelectInput', function() {

		});
		VS.Client.addCommand('rightArrowSelectInput', function() {
			
		});
		// confirm
		VS.Client.addCommand('closeConfirmMenu', function() {
			this.aInterfaceUtils.closeConfirmMenu();
		});
		VS.Client.addCommand('leftArrowSelectConfirm', function() {

		});
		VS.Client.addCommand('rightArrowSelectConfirm', function() {
			
		});

		// alert
		VS.Macro.newMacro('closeAlertMenu', 'aInterfaceUtils_alert_macro', 'Enter', 'closeAlertMenu');
		VS.Macro.newMacro('leftArrowSelectAlert', 'aInterfaceUtils_alert_macro', 'ArrowLeft', 'leftArrowSelectAlert');
		VS.Macro.newMacro('rightArrowSelectAlert', 'aInterfaceUtils_alert_macro', 'ArrowRight', 'rightArrowSelectAlert');
		// input
		VS.Macro.newMacro('closeInputMenu', 'aInterfaceUtils_input_macro', 'Enter', 'closeInputMenu');
		VS.Macro.newMacro('leftArrowSelectInput', 'aInterfaceUtils_input_macro', 'ArrowLeft', 'leftArrowSelectInput');
		VS.Macro.newMacro('rightArrowSelectInput', 'aInterfaceUtils_input_macro', 'ArrowRight', 'rightArrowSelectInput');
		// confirm
		VS.Macro.newMacro('closeConfirmMenu', 'aInterfaceUtils_confirm_macro', 'Enter', 'closeConfirmMenu');
		VS.Macro.newMacro('leftArrowSelectConfirm', 'aInterfaceUtils_confirm_macro', 'ArrowLeft', 'leftArrowSelectConfirm');
		VS.Macro.newMacro('rightArrowSelectConfirm', 'aInterfaceUtils_confirm_macro', 'ArrowRight', 'rightArrowSelectConfirm');
 */
		VS.Client.createInterface('aInterfaceUtils_alert_interface');
		VS.Client.createInterface('aInterfaceUtils_input_interface');
		VS.Client.createInterface('aInterfaceUtils_confirm_interface');

		// alert menu
		const alertMenu = VS.newDiob('Interface');
		alertMenu.atlasName = 'aInterfaceUtils_atlas';
		alertMenu.iconName = 'dialog_menu';
		alertMenu.width = 380;
		alertMenu.height = 185;
		alertMenu.layer = MAX_PLANE;
		alertMenu.plane = MAX_PLANE;
		alertMenu.alpha = 0.8;
		alertMenu.interfaceType = 'WebBox';
		alertMenu.itemsInQueue = 0;
		alertMenu.queuedAlerts = {};
		alertMenu.queueTracker = 0;
		alertMenu.name = 'alert_menu';
		alertMenu.dragOptions = { 'draggable': true, 'parent': true, 'titlebar': { 'width': 380, 'height': 34, 'xPos': 1, 'yPos': 0 }};
		alertMenu.textStyle = { 'vPadding': 7 };

		alertMenu.onFocus = function(pClient) {
			pClient.toggleMacroCapture(false);
		}
		alertMenu.onUnfocus = function(pClient) {
			pClient.toggleMacroCapture(true);
		}
		alertMenu.onShow = function(pClient) {
			for (const elem of pClient.getInterfaceElements('aInterfaceUtils_alert_interface')) {
				elem.setPos(elem.defaultPos.x, elem.defaultPos.y);
			}
			pClient.setFocus(this)
			this.super('onShow', arguments);
		}
		alertMenu.onHide = function(pClient) {
			pClient.setFocus();
			this.super('onHide', arguments);
		}

		// alert ok button
		const alertMenuOkButton = VS.newDiob('Interface');
		alertMenuOkButton.atlasName = 'aInterfaceUtils_atlas';
		alertMenuOkButton.iconName = 'dialog_button';
		alertMenuOkButton.interfaceType = 'WebBox';
		alertMenuOkButton.width = 85;
		alertMenuOkButton.height = 27;
		alertMenuOkButton.layer = MAX_PLANE;
		alertMenuOkButton.plane = MAX_PLANE;
		alertMenuOkButton.interfaceType = 'WebBox';
		alertMenuOkButton.textStyle = { 'vPadding': 7 };
		alertMenuOkButton.parentElement = 'alert_menu';
		alertMenuOkButton.text = '<div class="aInterfaceUtils_dialog_button">Ok</div>';

		alertMenuOkButton.onMouseEnter = function(pClient, pX, pY) {
			pClient.setMouseCursor('pointer');
			this.alpha = 0.8;
		}

		alertMenuOkButton.onMouseExit = function(pClient, pX, pY) {
			pClient.setMouseCursor('');
			this.alpha = 1;
		}

		alertMenuOkButton.onMouseClick = function(pClient, pX, pY, pButton) {
			if (pButton === 1 && this.isMousedDown()) {
				const alertMenuElem = pClient.getInterfaceElement('aInterfaceUtils_alert_interface', 'alert_menu');
				if (alertMenuElem.callback) {
					if (alertMenuElem.parameters) {
						alertMenuElem.callback(...alertMenuElem.parameters);
					} else {
						alertMenuElem.callback();
					}
				}
				aInterfaceUtils.closeAlertMenu();
			}
		}

		VS.Client.addInterfaceElement(alertMenu, 'aInterfaceUtils_alert_interface', 'alert_menu', 287, 178);
		VS.Client.addInterfaceElement(alertMenuOkButton, 'aInterfaceUtils_alert_interface', 'alert_menu_ok_button', 438, 312);
		VS.Client.onInterfaceLoaded('aInterfaceUtils_alert_interface');

		// input menu
		const inputMenu = VS.newDiob('Interface');
		inputMenu.atlasName = 'aInterfaceUtils_atlas';
		inputMenu.iconName = 'dialog_menu';
		inputMenu.width = 380;
		inputMenu.height = 185;
		inputMenu.layer = MAX_PLANE;
		inputMenu.plane = MAX_PLANE;
		inputMenu.alpha = 0.8;
		inputMenu.interfaceType = 'WebBox';
		inputMenu.inputValue = false;
		inputMenu.closing = false;
		/* inputMenu.storedMacroAtlas = ''; */
		inputMenu.itemsInQueue = 0;
		inputMenu.queuedInputs = {};
		inputMenu.queueTracker = 0;
		inputMenu.name = 'input_menu';
		inputMenu.dragOptions = { 'draggable': true, 'parent': true, 'titlebar': { 'width': 380, 'height': 34, 'xPos': 1, 'yPos': 0 }};
		inputMenu.textStyle = {
			'fontFamily': 'Arial',
			'fontSize': 14,
			'vPadding': 36,
			'padding': 13,
			'fill': '#ffffff'
		}

		inputMenu.onFocus = function(pClient) {
			/* this.storedMacroAtlas = pClient._vy_macroAtlas; */
			pClient.toggleMacroCapture(false);
			pClient.aInterfaceUtils.inInput = true;
			/* pClient.setMacroAtlas('aInterfaceUtils_input_macro'); */
		}

		inputMenu.onUnfocus = function(pClient) {
			pClient.toggleMacroCapture(true);
			pClient.aInterfaceUtils.inInput = false;
		}

		inputMenu.onShow = function(pClient) {
			for (const elem of pClient.getInterfaceElements('aInterfaceUtils_input_interface')) {
				elem.setPos(elem.defaultPos.x, elem.defaultPos.y);
			}
			pClient.setFocus(this);
			this.super('onShow', arguments);
		}

		inputMenu.onHide = function(pClient) {
			pClient.setFocus();
			this.super('onHide', arguments);
		}

		// input
		const inputMenuInput = VS.newDiob('Interface');
		inputMenuInput.atlasName = 'aInterfaceUtils_atlas';
		inputMenuInput.iconName = 'dialog_input';
		inputMenuInput.width = 352;
		inputMenuInput.height = 25;
		inputMenuInput.layer = MAX_PLANE;
		inputMenuInput.plane = MAX_PLANE;
		inputMenuInput.interfaceType = 'CommandInput';
		inputMenuInput.parentElement = 'input_menu';
		inputMenuInput.textStyle = { 'hPadding': 4, 'fill': '#fff' };
		inputMenuInput.onExecute = function(pClient) {
			const inputMenuOkButton = pClient.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu_ok_button')
			inputMenuOkButton.close(pClient)
		}

		// input ok button
		const inputMenuOkButton = VS.newDiob('Interface');
		inputMenuOkButton.atlasName = 'aInterfaceUtils_atlas';
		inputMenuOkButton.iconName = 'dialog_button';
		inputMenuOkButton.width = 85;
		inputMenuOkButton.height = 27;
		inputMenuOkButton.layer = MAX_PLANE;
		inputMenuOkButton.plane = MAX_PLANE;
		inputMenuOkButton.interfaceType = 'WebBox';
		inputMenuOkButton.parentElement = 'input_menu';
		inputMenuOkButton.textStyle = { 'vPadding': 7 };
		inputMenuOkButton.text = '<div class="aInterfaceUtils_dialog_button">Ok</div>';
		inputMenuOkButton.close = function(pClient) {
			const inputMenu = pClient.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu');
			aInterfaceUtils.closeInputMenu();
			if (inputMenu.closing) {
				if (inputMenu.callback && typeof(inputMenu.callback) === 'function') {
					if (inputMenu.parameters) {
						inputMenu.callback(inputMenu.inputValue, ...inputMenu.parameters);
					} else {
						inputMenu.callback(inputMenu.inputValue);
					}
				}
			}
		}
		inputMenuOkButton.onMouseEnter = function(pClient, pX, pY) {
			pClient.setMouseCursor('pointer');
			this.alpha = 0.8;
		}

		inputMenuOkButton.onMouseExit = function(pClient, pX, pY) {
			pClient.setMouseCursor('');
			this.alpha = 1;
		}

		inputMenuOkButton.onMouseClick = function(pClient, pX, pY, pButton) {
			if (pButton === 1 && this.isMousedDown()) {
				this.close(pClient)
			}
		}
		VS.Client.addInterfaceElement(inputMenu, 'aInterfaceUtils_input_interface', 'input_menu', 287, 178);
		VS.Client.addInterfaceElement(inputMenuInput, 'aInterfaceUtils_input_interface', 'input_menu_input', 304, 258);
		VS.Client.addInterfaceElement(inputMenuOkButton, 'aInterfaceUtils_input_interface', 'input_menu_ok_button', 438, 312);
		VS.Client.onInterfaceLoaded('aInterfaceUtils_input_interface');

		aInterfaceUtils.useNumbersOnly = function() {
			this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');
		}

		// confirm menu
		const confirmMenu = VS.newDiob('Interface');
		confirmMenu.atlasName = 'aInterfaceUtils_atlas';
		confirmMenu.iconName = 'dialog_menu';
		confirmMenu.width = 380;
		confirmMenu.height = 185;
		confirmMenu.layer = MAX_PLANE;
		confirmMenu.plane = MAX_PLANE;
		confirmMenu.alpha = 0.8;
		confirmMenu.interfaceType = 'WebBox';
		confirmMenu.itemsInQueue = 0;
		confirmMenu.queuedDialogs = {};
		confirmMenu.queueTracker = 0;
		confirmMenu.textStyle = {
			'fontFamily': 'Arial',
			'fontSize': 14,
			'vPadding': 7,
			'fill': '#ffffff',
		};
		confirmMenu.name = 'confirm_menu';
		confirmMenu.dragOptions = { 'draggable': true, 'parent': true, 'titlebar': { 'width': 380, 'height': 34, 'xPos': 1, 'yPos': 0 }};
		confirmMenu.onFocus = function(pClient) {
			pClient.toggleMacroCapture(false);
		}
		confirmMenu.onUnfocus = function(pClient) {
			pClient.toggleMacroCapture(true);
		}
		confirmMenu.onShow = function(pClient) {
			for (const elem of pClient.getInterfaceElements('aInterfaceUtils_confirm_interface')) {
				elem.setPos(elem.defaultPos.x, elem.defaultPos.y);
			}
			pClient.setFocus(this);
			this.super('onShow', arguments);
		}
		confirmMenu.onHide = function(pClient) {
			pClient.setFocus();
			this.super('onHide', arguments);
		}
		// confirm yes button
		const confirmMenuYesButton = VS.newDiob('Interface');
		confirmMenuYesButton.atlasName = 'aInterfaceUtils_atlas';
		confirmMenuYesButton.iconName = 'dialog_button';
		confirmMenuYesButton.width = 85;
		confirmMenuYesButton.height = 27;
		confirmMenuYesButton.layer = MAX_PLANE;
		confirmMenuYesButton.plane = MAX_PLANE;
		confirmMenuYesButton.interfaceType = 'WebBox';
		confirmMenuYesButton.parentElement = 'confirm_menu';
		confirmMenuYesButton.textStyle = { 
			'fontSize': 11, 
			'fill': '#fff', 
			'vPadding': 7 
		};
		confirmMenuYesButton.text = '<div class="aInterfaceUtils_dialog_button">Yes</div>';
		confirmMenuYesButton.onMouseEnter = function(pClient, pX, pY) {
			pClient.setMouseCursor('pointer');
			this.alpha = 0.8;
		}

		confirmMenuYesButton.onMouseExit = function(pClient, pX, pY) {
			pClient.setMouseCursor('');
			this.alpha = 1;
		}

		confirmMenuYesButton.onMouseClick = function(pClient, pX, pY, pButton) {
			if (pButton === 1 && this.isMousedDown()) {
				const confirmMenu = pClient.getInterfaceElement('aInterfaceUtils_confirm_interface', 'confirm_menu');
				if (confirmMenu.callback && typeof(confirmMenu.callback) === 'function') {
					if (confirmMenu.parameters) {
						confirmMenu.callback(true, ...confirmMenu.parameters);
					} else {
						confirmMenu.callback(true);
					}
				}
				aInterfaceUtils.closeConfirmMenu();
			}
		}
		// confirm no button
		const confirmMenuNoButton = VS.newDiob('Interface');
		confirmMenuNoButton.atlasName = 'aInterfaceUtils_atlas';
		confirmMenuNoButton.iconName = 'dialog_button';
		confirmMenuNoButton.width = 85;
		confirmMenuNoButton.height = 27;
		confirmMenuNoButton.layer = MAX_PLANE;
		confirmMenuNoButton.plane = MAX_PLANE;
		confirmMenuNoButton.interfaceType = 'WebBox';
		confirmMenuNoButton.parentElement = 'confirm_menu';
		confirmMenuNoButton.textStyle = { 
			'fontSize': 11, 
			'fill': '#fff', 
			'vPadding': 7 
		};
		confirmMenuNoButton.text = '<div class="aInterfaceUtils_dialog_button">No</div>';
		confirmMenuNoButton.onMouseEnter = function(pClient, pX, pY) {
			pClient.setMouseCursor('pointer');
			this.alpha = 0.8;
		}

		confirmMenuNoButton.onMouseExit = function(pClient, pX, pY) {
			pClient.setMouseCursor('');
			this.alpha = 1;
		}

		confirmMenuNoButton.onMouseClick = function(pClient, pX, pY, pButton) {
			if (pButton === 1 && this.isMousedDown()) {
				const confirmMenu = pClient.getInterfaceElement('aInterfaceUtils_confirm_interface', 'confirm_menu');
				if (confirmMenu.callback && typeof(confirmMenu.callback) === 'function') {
					if (confirmMenu.parameters) {
						confirmMenu.callback(false, ...confirmMenu.parameters);
					} else {
						confirmMenu.callback(false);
					}
				}
				aInterfaceUtils.closeConfirmMenu();
			}
		}
		VS.Client.addInterfaceElement(confirmMenu, 'aInterfaceUtils_confirm_interface', 'confirm_menu', 287, 178);
		VS.Client.addInterfaceElement(confirmMenuYesButton, 'aInterfaceUtils_confirm_interface', 'confirm_menu_yes_button', 396, 315);
		VS.Client.addInterfaceElement(confirmMenuNoButton, 'aInterfaceUtils_confirm_interface', 'confirm_menu_no_button', 486, 315);
		VS.Client.onInterfaceLoaded('aInterfaceUtils_confirm_interface');

		aInterfaceUtils.alert = function(pTitle, pMessage, pCallback, pParameters) {
			const alertMenu = VS.Client.getInterfaceElement('aInterfaceUtils_alert_interface', 'alert_menu');
			let num;
			let message;
			let title;
			let callback;
			let parameters;

			if (alertMenu.shown) {
				alertMenu.itemsInQueue++;
				num = alertMenu.itemsInQueue;
				message = 'message' + num;
				title = 'title' + num;
				callback = 'callback' + num;
				parameters = 'parameters' + num;
				alertMenu.queuedAlerts[message] = pMessage;
				alertMenu.queuedAlerts[title] = pTitle;
				alertMenu.queuedAlerts[callback] = pCallback;
				alertMenu.queuedAlerts[parameters] = pParameters;
				return;
			}

			alertMenu.callback = pCallback;
			alertMenu.parameters = pParameters;
			for (const elem of VS.Client.getInterfaceElements('aInterfaceUtils_alert_interface')) {
				elem.show();
				if (elem.name === 'alert_menu') {
					elem.text = '<div class="aInterfaceUtils_center_title">' + pTitle + '</div><div class="aInterfaceUtils_dialog">' + pMessage + '</div>';
				}
			}
			this.inDialog = true;
		}

		aInterfaceUtils.closeAlertMenu = function() {
			const alertMenu = VS.Client.getInterfaceElement('aInterfaceUtils_alert_interface', 'alert_menu');
			let count;
			
			VS.Client.hideInterface('aInterfaceUtils_alert_interface');

			if (alertMenu.itemsInQueue) {
				alertMenu.queueTracker++;
				count = alertMenu.queueTracker;
				setTimeout(function() {
					VS.Client.aInterfaceUtils.alert(alertMenu.queuedAlerts['message' + count], alertMenu.queuedAlerts['title' + count], alertMenu.queuedAlerts['callback' + count], alertMenu.queuedAlerts['parameters' + count]);
				}, 500);
				alertMenu.itemsInQueue--;
			} else {
				alertMenu.itemsInQueue = 0;
				alertMenu.queueTracker = 0;
				alertMenu.queuedAlerts = {};
			}
			alertMenu.text = '';
			this.inDialog = false;
		}

		aInterfaceUtils.input = function(pText, pDefaultText, pNumbersOnly=false, pCallback, pParameters) {
			const inputMenu = VS.Client.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu');
			const inputText = VS.Client.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu_input');
			let num;
			let text;
			let defaultText;
			let numbersOnly;
			let callback;
			let parameters;
			/* inputMenu.storedMacroAtlas = VS.Client._vy_macroAtlas; */

			if (inputMenu.shown) {
				inputMenu.itemsInQueue++
				num = inputMenu.itemsInQueue;
				text = 'text' + num;
				defaultText = 'defaultText' + num;
				numbersOnly = 'numbersOnly' + num;
				callback = 'callback' + num;
				parameters = 'parameters' + num;
				inputMenu.queuedInputs[text] = pText;
				inputMenu.queuedInputs[defaultText] = pDefaultText;
				inputMenu.queuedInputs[numbersOnly] = pNumbersOnly;
				inputMenu.queuedInputs[callback] = pCallback;
				inputMenu.queuedInputs[parameters] = pParameters;
				return;
			}
				
			inputMenu.closing = false;
			inputMenu.defaultText = pDefaultText;
			inputMenu.numbersOnly = pNumbersOnly;
			inputMenu.callback = pCallback;
			inputMenu.parameters = pParameters;
			// needs to be shown to create dom element
			inputText.show();
			if (inputText.getDOM().children[0]) {
				inputText.getDOM().children[0].placeholder = pDefaultText;
			}

			if (pNumbersOnly) {
				document.getElementById('ti_aInterfaceUtils_input_interface_input_menu_input').addEventListener('input', this.useNumbersOnly);
			}
			
			for (const elem of VS.Client.getInterfaceElements('aInterfaceUtils_input_interface')) {
				elem.show();
				if (elem.name === 'input_menu') {
					elem.text = '<div class="aInterfaceUtils_input">' + pText + '</div>', 'input_interface';
				}
			}
			this.inInput = true;
		}

		aInterfaceUtils.closeInputMenu = function() {
			const inputMenu = VS.Client.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu');
			const inputText = VS.Client.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu_input');
			const inputOk = VS.Client.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu_ok_button');
			let count;

			inputMenu.inputValue = inputText.text;
			if (!inputMenu.inputValue) {
				// shake error animation here
				return;
			}

			if (inputMenu.numbersOnly) {
				document.getElementById('ti_aInterfaceUtils_input_interface_input_menu_input').removeEventListener('input', this.useNumbersOnly);
			}

			VS.Client.hideInterface('aInterfaceUtils_input_interface');

			inputMenu.closing = true;
			
			if (inputMenu.itemsInQueue) {
				inputMenu.queueTracker++;
				count = inputMenu.queueTracker;
				setTimeout(function() {
					VS.Client.aInterfaceUtils.input(inputMenu.queuedInputs['text' + count], inputMenu.queuedInputs['defaultText' + count], inputMenu.queuedInputs['numbersOnly' + count], inputMenu.queuedInputs['callback' + count], inputMenu.queuedInputs['parameters' + count]);
				}, 500);
				inputMenu.itemsInQueue--;
			} else {
				inputMenu.itemsInQueue = 0;
				inputMenu.queueTracker = 0;
				inputMenu.queuedInputs = {};
			}
			inputMenu.text = '';
			inputText.text = '';
			this.inInput = false;
			/* VS.Client.setMacroAtlas(inputMenu.storedMacroAtlas); */
		}

		aInterfaceUtils.confirm = function(pTitle, pMessage, pCallback, pParameters) {
			const confirmMenu = VS.Client.getInterfaceElement('aInterfaceUtils_confirm_interface', 'confirm_menu');
			let num;
			let message;
			let title;
			let callback;
			let parameters;
			
			if (confirmMenu.shown) {
				confirmMenu.itemsInQueue++;
				num = confirmMenu.itemsInQueue;
				message = 'message' + num;
				title = 'title' + num;
				callback = 'callback' + num;
				parameters = 'parameters' + num;
				confirmMenu.queuedDialogs[message] = pMessage;
				confirmMenu.queuedDialogs[title] = pTitle;
				confirmMenu.queuedDialogs[callback] = pCallback;
				confirmMenu.queuedDialogs[parameters] = pParameters;
				return;
			}

			confirmMenu.callback = pCallback;
			confirmMenu.parameters = pParameters;
			
			for (const elem of VS.Client.getInterfaceElements('aInterfaceUtils_confirm_interface')) {
				elem.show();
				if (elem.name === 'confirm_menu') {
					elem.text = '<div class="aInterfaceUtils_center_title">' + pTitle + '</div><div class="aInterfaceUtils_dialog">' + pMessage + '</div>';
				}
			}
					
			this.inDialog = true;
		}

		aInterfaceUtils.closeConfirmMenu = function() {
			const confirmMenu = VS.Client.getInterfaceElement('aInterfaceUtils_confirm_interface', 'confirm_menu');
			const acceptButton = VS.Client.getInterfaceElement('aInterfaceUtils_confirm_interface', 'confirm_menu_yes_button');
			const closeButton = VS.Client.getInterfaceElement('aInterfaceUtils_confirm_interface', 'confirm_menu_no_button');
			let count;		
			
			VS.Client.hideInterface('aInterfaceUtils_confirm_interface');

			if (confirmMenu.itemsInQueue) {
				confirmMenu.queueTracker++;
				count = confirmMenu.queueTracker;
				setTimeout(function() {
					VS.Client.aInterfaceUtils.confirm(confirmMenu.queuedDialogs['message' + count], confirmMenu.queuedDialogs['title' + count], confirmMenu.queuedDialogs['callback' + count], confirmMenu.queuedDialogs['parameters' + count]);
				}, 500);
				confirmMenu.itemsInQueue--;
			} else {
				confirmMenu.itemsInQueue = 0;
				confirmMenu.queueTracker = 0;
				confirmMenu.queuedDialogs = {};
			}
			confirmMenu.text = '';
			this.inDialog = false;
		}
	}

	const buildInterfaceUtils = (aInterfaceUtils) => {
		VS.World.global.aInterfaceUtils = aInterfaceUtils;
		VS.Type.setVariables('Client', { '___EVITCA_aInterfaceUtils': true });

		const isMousedDown = function() {
			if (VS.Client._mousedDowned === this && !VS.Client.dragging) {
				return true;
			}
			return false;
		}

		// give this isMousedDown function to the diob type
		VS.Type.setFunction('Diob', 'isMousedDown', isMousedDown);

		const superFunction = function(pFunctionName, pArgs) {
			if (this.parentType || this.baseType) {
				VS.Type.callFunction((this.parentType ? this.parentType : this.baseType), pFunctionName, this, ...pArgs);
			}
		}

		VS.Type.setFunction('Diob', 'super', superFunction);
		
		// store the original onConnect function if there is one
		aInterfaceUtils._onNewClient = VS.Type.getFunction('Client', 'onNew');

		// the function that will be used as the `pClient.onConnect` function
		const onNewClient = function() {
			this._screenScale = { 'x': 1, 'y': 1 };
			this._windowSize = this.getWindowSize();
			this._gameSize = VS.World.getGameSize();
			this.getScreenScale(this._screenScale);
			this._dragging = { 'element': null, 'xOff': 0, 'yOff': 0 };
			this._mousedDowned = null;
			this.dragging = false;
			if (VS.World.global.aInterfaceUtils._onNewClient) {
				VS.World.global.aInterfaceUtils._onNewClient.apply(this);
			}
		}

		// assign the custom onConnect function to the client
		VS.Type.setFunction('Client', 'onNew', onNewClient);

		// store the original onWindowFocus function if there is one
		aInterfaceUtils._onWindowFocus = VS.Type.getFunction('Client', 'onWindowFocus');

		// the function that will be used as the `pClient.onWindowFocus` function
		const onWindowFocus = function() {
			VS.World.global.aInterfaceUtils.preventMouseMoveEvent = true;
			if (VS.World.global.aInterfaceUtils._onWindowFocus) {
				VS.World.global.aInterfaceUtils._onWindowFocus.apply(this);
			}
		}

		// assign the custom onWindowFocus function to the client
		VS.Type.setFunction('Client', 'onWindowFocus', onWindowFocus);

		// store the original onWindowResize function if there is one
		aInterfaceUtils._onWindowResize = VS.Type.getFunction('Client', 'onWindowResize');

		// the function that will be used as the `pClient.onWindowResize` function
		const onWindowResize = function(pWidth, pHeight) {
			if (this._windowSize) {
				this._windowSize.width = pWidth;
				this._windowSize.height = pHeight;
			}
			this.getScreenScale(this._screenScale);
			if (this.___EVITCA_aInventory) {
				this.aInventory.outlineFilter.thickness = this.aInventory.outlineDefaultThickness * mainM.mapScaleWidth;
			}
			if (this.aInterfaceUtils._onWindowResize) {
				this.aInterfaceUtils._onWindowResize.apply(this, arguments);
			}
		}

		// assign the custom onWindowResize function to the client
		VS.Type.setFunction('Client', 'onWindowResize', onWindowResize);

		// store the original onInterfaceLoaded function if there is one
		aInterfaceUtils._onInterfaceLoaded = VS.Type.getFunction('Client', 'onInterfaceLoaded');

		// the function that will be used as the `pClient.onInterfaceLoaded` function
		const onInterfaceLoaded = function(pInterface) {
			let protruding;
			let protrudingDirection;
			for (const x of this.getInterfaceElements(pInterface)) {
				if (x.dragOptions.draggable && x.dragOptions.parent) {
					protruding = x._protruding;
				}
			}

			for (const element of this.getInterfaceElements(pInterface)) {
				if (protruding) {
					element._protruding = protruding;
					protrudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][element._protruding.east | (element._protruding.west << 1) | (element._protruding.north << 2) | (element._protruding.south << 3)];
				}

				if (element.dragOptions.draggable && element.dragOptions.parent) {
					if (protrudingDirection === 'none') {
						element.dragOptions.clampedPos = { 'x': { 'maxPos': 0, 'minPos': 0 }, 'y': { 'maxPos': 0, 'minPos': 0 } };
						continue;
					}

					if (protrudingDirection === 'e' || protrudingDirection === 'en' || protrudingDirection === 'es' || protrudingDirection === 'ens') {
						element.dragOptions.clampedPos.x = { 'maxPos': element.dragOptions.protrudingChildren.x.maxPos - element.xPos - element.width + element.dragOptions.protrudingChildren.x.maxWidth, 'minPos': 0 };
					}

					if (protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ws' || protrudingDirection === 'wns') {
						element.dragOptions.clampedPos.x = { 'maxPos': 0, 'minPos': element.xPos - element.dragOptions.protrudingChildren.x.minPos };
					}

					if (protrudingDirection === 'ew' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns') {
						element.dragOptions.clampedPos.x = { 'maxPos': element.dragOptions.protrudingChildren.x.maxPos - element.xPos - element.width + element.dragOptions.protrudingChildren.x.maxWidth, 'minPos': element.xPos - element.dragOptions.protrudingChildren.x.minPos };
					}

					if (protrudingDirection === 'n' || protrudingDirection === 'en' || protrudingDirection === 'wn' || protrudingDirection === 'ewn') {
						element.dragOptions.clampedPos.y = { 'maxPos': 0, 'minPos': element.yPos - element.dragOptions.protrudingChildren.y.minPos };
					}

					if (protrudingDirection === 's' || protrudingDirection === 'es' || protrudingDirection === 'ws' || protrudingDirection === 'ews') {
						element.dragOptions.clampedPos.y = { 'maxPos': element.dragOptions.protrudingChildren.y.maxPos - element.yPos - element.height + element.dragOptions.protrudingChildren.y.maxHeight, 'minPos': 0 };
					}

					if (protrudingDirection === 'sn' || protrudingDirection === 'ens' || protrudingDirection === 'wns' || protrudingDirection === 'ewns') {
						element.dragOptions.clampedPos.y = { 'maxPos': element.dragOptions.protrudingChildren.y.maxPos - element.yPos - element.height + element.dragOptions.protrudingChildren.y.maxHeight, 'minPos': element.yPos - element.dragOptions.protrudingChildren.y.minPos };
					}
					continue;
				}

				if (element.parentElement) {
					const parent = this.getInterfaceElement(pInterface, element.parentElement);
					const noneX = Math.sign(element.xPos - parent.xPos) === -1 ? 0 : element.xPos - parent.xPos;
					const noneY = Math.sign(element.yPos - parent.yPos) === -1 ? 0 : element.yPos - parent.yPos;
					element.dragOptions.owner = parent;

					if (protrudingDirection === 'none') {
						element.dragOptions.clampedPos.x.maxPos = Math.sign(element.xPos - parent.xPos) === -1 ? 0 : element.xPos - parent.xPos;
						element.dragOptions.clampedPos.x.minPos = element.dragOptions.clampedPos.x.maxPos;
						element.dragOptions.clampedPos.y.maxPos = Math.sign(element.yPos - parent.yPos) === -1 ? 0 : element.yPos - parent.yPos;
						element.dragOptions.clampedPos.y.minPos = element.dragOptions.clampedPos.y.maxPos;
						continue;
					}

					if (protrudingDirection === 'n' || protrudingDirection === 's' || protrudingDirection === 'sn') {
						element.dragOptions.clampedPos.x = { 'maxPos': noneX, 'minPos': noneX };
					}

					if (protrudingDirection === 'e' || protrudingDirection === 'es' || protrudingDirection === 'en' || protrudingDirection === 'ens') {
						element.dragOptions.clampedPos.x = { 'maxPos': parent.dragOptions.protrudingChildren.x.maxPos - element.xPos + element.width, 'minPos': noneX };
					}

					if (protrudingDirection === 'w' || protrudingDirection === 'ws' || protrudingDirection === 'wns' || protrudingDirection === 'wn') {
						element.dragOptions.clampedPos.x = { 'maxPos': element.xPos - parent.xPos, 'minPos': element.xPos - parent.dragOptions.protrudingChildren.x.minPos };
					}

					if (protrudingDirection === 'ew' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns') {
						element.dragOptions.clampedPos.x = { 'maxPos': parent.dragOptions.protrudingChildren.x.maxPos - element.xPos + element.width, 'minPos': element.xPos - parent.dragOptions.protrudingChildren.x.minPos };
					}

					if (protrudingDirection === 'n' || protrudingDirection === 'wn' || protrudingDirection === 'en' || protrudingDirection === 'ewn') {
						element.dragOptions.clampedPos.y = { 'maxPos': element.yPos - parent.yPos, 'minPos': element.yPos - parent.dragOptions.protrudingChildren.y.minPos };
					}

					if (protrudingDirection === 's' || protrudingDirection === 'ws' || protrudingDirection === 'es' || protrudingDirection === 'ews') {
						element.dragOptions.clampedPos.y = { 'maxPos': parent.dragOptions.protrudingChildren.y.maxPos - element.yPos + element.height, 'minPos': noneY };
					}

					if (protrudingDirection === 'e' || protrudingDirection === 'w' || protrudingDirection === 'ew') {
						element.dragOptions.clampedPos.y = { 'maxPos': noneY, 'minPos': noneY };
					}

					if (protrudingDirection === 'sn' || protrudingDirection === 'ens' || protrudingDirection === 'wns' || protrudingDirection === 'ewns') {
						element.dragOptions.clampedPos.y = { 'maxPos': parent.dragOptions.protrudingChildren.y.maxPos - element.yPos + element.height, 'minPos': element.yPos - parent.dragOptions.protrudingChildren.y.minPos };
					}
				}
			}
			if (VS.World.global.aInterfaceUtils._onInterfaceLoaded) {
				VS.World.global.aInterfaceUtils._onInterfaceLoaded.apply(this, arguments);
			}
		}

		// assign the custom onInterfaceLoaded function to the client
		VS.Type.setFunction('Client', 'onInterfaceLoaded', onInterfaceLoaded);

		// store the original onMouseMove function if there is one
		aInterfaceUtils._onMouseMove = VS.Type.getFunction('Client', 'onMouseMove');

		// the function that will be used as the `pClient.onMouseMove` function
		const onMouseMove = function(pDiob, pX, pY) {
			if (this._dragging.element) {
				if (this.aInterfaceUtils.preventMouseMoveEvent) {
					this.aInterfaceUtils.preventMouseMoveEvent = false;
					return;
				}
				const MAX_PLANE = 999999;
				let realX = (this._dragging.element.preventAutoScale ? pX * this._screenScale.x : pX) - this._dragging.xOff;
				let realY = (this._dragging.element.preventAutoScale ? pY * this._screenScale.y : pY) - this._dragging.yOff;
				let maxWidth;
				let maxHeight;

				if (!this.dragging) {
					this.dragging = true;
				}

				if (this.dragging) {
					if (this._dragging.element.dragOptions.titlebar) {
						if (this._dragging.element.dragOptions.titlebar.xPos >= 0 && this._dragging.element.dragOptions.titlebar.yPos >= 0 && this._dragging.element.dragOptions.titlebar.width > 0 && this._dragging.element.dragOptions.titlebar.height > 0) {
/* 							const titleBarX = this._dragging.element.xPos + this._dragging.element.dragOptions.titlebar.xPos;
							const titleBarWidthX = titleBarX + this._dragging.element.dragOptions.titlebar.width;
							const titleBarY = this._dragging.element.yPos + this._dragging.element.dragOptions.titlebar.yPos;
							const titleBarHeightY = titleBarY + this._dragging.element.dragOptions.titlebar.height; 
*/
							maxWidth = (this._dragging.element.preventAutoScale ? this._windowSize.width : this._gameSize.width) - this._dragging.element.width;
							maxHeight = (this._dragging.element.preventAutoScale ? this._windowSize.height : this._gameSize.height) - this._dragging.element.height;
						} else {
							maxWidth = (this._dragging.element.preventAutoScale ? this._windowSize.width : this._gameSize.width) - this._dragging.element.width;
							maxHeight = (this._dragging.element.preventAutoScale ? this._windowSize.height : this._gameSize.height) - this._dragging.element.height;
						}
					} else {
						maxWidth = (this._dragging.element.preventAutoScale ? this._windowSize.width : this._gameSize.width) - this._dragging.element.width;
						maxHeight = (this._dragging.element.preventAutoScale ? this._windowSize.height : this._gameSize.height) - this._dragging.element.height;
					}

					this._dragging.element.setPos(Math.clamp(realX, this._dragging.element.dragOptions.clampedPos.x.minPos, maxWidth - this._dragging.element.dragOptions.clampedPos.x.maxPos), Math.clamp(realY, this._dragging.element.dragOptions.clampedPos.y.minPos, maxHeight - this._dragging.element.dragOptions.clampedPos.y.maxPos));

					if (this._dragging.element.onMove && typeof(this._dragging.element.onMove) === 'function') {
						this._dragging.element.onMove();
					}

					if (this._dragging.element.dragOptions.parent) {
						realX += this._dragging.xOff;
						realY += this._dragging.yOff;

						for (const element of this.getInterfaceElements(this._dragging.element.interfaceName)) {
							if (element !== this._dragging.element) {
								if (element.parentElement === this._dragging.element.name) {
									element.reposition(realX, realY, this._dragging.element.defaultPos.x, this._dragging.element.defaultPos.y);
									if (element.onMove && typeof(element.onMove) === 'function') {
										element.onMove();
									}
								}
							}
						}
					}

					if (this._dragging.element.dragOptions.beingDragged) {
						return;
					}

					this._dragging.element.dragOptions.beingDragged = true;

					if (this._dragging.element.onDragStart && typeof(this._dragging.element.onDragStart) === 'function') {
						this._dragging.element.onDragStart();
					}
					// automatically dynamically relayer this element when dragging it so its above everything else
					this._dragging.element.plane += MAX_PLANE;
					this._dragging.element.layer += MAX_PLANE;

					for (const childElem of this.getInterfaceElements(this._dragging.element.interfaceName)) {
						if (childElem !== this._dragging.element) {
							if (childElem.parentElement === this._dragging.element.name) {
								// automatically dynamically relayer the children element when dragging it so its above everything else
								childElem.plane += MAX_PLANE;
								childElem.layer += MAX_PLANE;
								if (childElem.onDragStart && typeof(childElem.onDragStart) === 'function') {
									childElem.onDragStart();
								}
							}
						}
					}
				}
			}

			if (this.aInterfaceUtils._onMouseMove) {
				this.aInterfaceUtils._onMouseMove.apply(this, arguments);
			}
		}

		// assign the custom onMouseMove function to the client
		VS.Type.setFunction('Client', 'onMouseMove', onMouseMove);

		// store the original onMouseDown function if there is one
		aInterfaceUtils._onMouseDown = VS.Type.getFunction('Client', 'onMouseDown');

		// the function that will be used as the `pClient.onMouseDown` function
		const onMouseDown = function(pDiob, pX, pY, pButton) {
			if (pButton === 1) {
				this._mousedDowned = pDiob;
				if (pDiob.baseType === 'Interface') {
					if (pDiob.dragOptions.draggable) {
						const realX = (pDiob.preventAutoScale ? pX * this._screenScale.x : pX);
						const realY = (pDiob.preventAutoScale ? pY * this._screenScale.y : pY);
						if (pDiob.dragOptions?.titlebar?.xPos >= 0 && pDiob.dragOptions?.titlebar?.yPos >= 0 && pDiob.dragOptions?.titlebar?.width > 0 && pDiob.dragOptions?.titlebar?.height > 0) {
							const titleBarX = pDiob.xPos + pDiob.dragOptions.titlebar.xPos;
							const titleBarWidthX = titleBarX + pDiob.dragOptions.titlebar.width;
							const titleBarY = pDiob.yPos + pDiob.dragOptions.titlebar.yPos;
							const titleBarHeightY = titleBarY + pDiob.dragOptions.titlebar.height;
							if (realX >= titleBarX && realX <= titleBarWidthX && realY >= titleBarY && realY <= titleBarHeightY) {
								this._dragging.element = pDiob;
								this._dragging.xOff = realX - titleBarX + pDiob.dragOptions.titlebar.xPos;
								this._dragging.yOff = realY - titleBarY + pDiob.dragOptions.titlebar.yPos;
							}
							return;
						}

						this._dragging.element = pDiob;
						this._dragging.xOff = realX - pDiob.xPos;
						this._dragging.yOff = realY - pDiob.yPos;
					}
				}
			}
			if (this.aInterfaceUtils._onMouseDown) {
				this.aInterfaceUtils._onMouseDown.apply(this, arguments);
			}
		}

		// assign the custom onMouseDown function to the client
		VS.Type.setFunction('Client', 'onMouseDown', onMouseDown);

		// store the original onMouseUp function if there is one
		aInterfaceUtils._onMouseUp = VS.Type.getFunction('Client', 'onMouseUp');

		const releaseElement = function() {
			const MAX_PLANE = 999999;
			const self = this;
			if (this._dragging.element.dragOptions.beingDragged) {
				if (this._dragging.element.onDragEnd && typeof(this._dragging.element.onDragEnd) === 'function') {
					this._dragging.element.onDragEnd();
				}

				// automatically dynamically relayer this element when you stop dragging it so it gets its original layering
				this._dragging.element.plane -= MAX_PLANE;
				this._dragging.element.layer -= MAX_PLANE;

				for (const childElem of this.getInterfaceElements(this._dragging.element.interfaceName)) {
					if (childElem !== this._dragging.element) {
						if (childElem.parentElement === this._dragging.element.name) {
							// automatically dynamically relayer the children elements as well when you stop dragging it so they get their original layering
							childElem.plane -= MAX_PLANE;
							childElem.layer -= MAX_PLANE;
							if (childElem.onDragEnd && typeof(childElem.onDragEnd) === 'function') {
								childElem.onDragEnd();
							}
						}
					}
				}
			}
			setTimeout(() => {
				self._dragging.element.dragOptions.beingDragged = false;
				self._dragging.element = null;
				self.dragging = false;
			});
		}

		// the function that will be used as the `pClient.onMouseUp` function
		const onMouseUp = function(pDiob, pX, pY, pButton) {
			if (pButton === 1) {
				if (this._dragging.element) {
					this.releaseElement();
				}
			}

			if (this.aInterfaceUtils._onMouseUp) {
				this.aInterfaceUtils._onMouseUp.apply(this, arguments);
			}
		}

		// assign the release element function to the Client type
		VS.Type.setFunction('Client', 'releaseElement', releaseElement);
		// assign the custom onMouseUp function to the Client type
		VS.Type.setFunction('Client', 'onMouseUp', onMouseUp);
		VS.Type.setVariables('Interface', { 'scale': { 'x': 1, 'y': 1 }, 'anchor': { 'x': 0.5, 'y': 0.5 }, '_protruding': { 'east': false, 'west': false, 'north': false, 'south': false }, 'dragOptions': { 'draggable': false, 'beingDragged': false, 'parent': false, 'clampedPos': { 'x': { 'maxPos': 0, 'minPos': 0 }, 'y': { 'maxPos': 0, 'minPos': 0 } }, 'titlebar': { 'width': 0, 'height': 0, 'xPos': 0, 'yPos': 0 } } })

		aInterfaceUtils.handleMouseOverDragArea = function(pReset) {
			if (pReset) {
				// If the aInventory library is present, you cannot change the mouse cursor if a slot is being held
				if (VS.Client.___EVITCA_aInventory) {
					// When you are dragging something from an inventory this will not allow the mouse cursor to be changed.
					if (!VS.Client.aInventory.isHoldingSlot) {
						VS.Client.setMouseCursor('');
						VS.Client.aInterfaceUtils.cursor = '';
					}				
				} else {
					VS.Client.setMouseCursor('');
					VS.Client.aInterfaceUtils.cursor = '';
				}
				return;
			}
			// If the aInventory library is present, you cannot change the mouse cursor if a slot is being held
			if (VS.Client.___EVITCA_aInventory) {
				// When you are dragging something from an inventory this will not allow the mouse cursor to be changed.
				if (!VS.Client.aInventory.isHoldingSlot) {
					VS.Client.setMouseCursor('move');
					VS.Client.aInterfaceUtils.cursor = 'move';
				}
			} else if (VS.Client.aInterfaceUtils.cursor !== 'move') {
				VS.Client.setMouseCursor('move');
				VS.Client.aInterfaceUtils.cursor = 'move';
			}
		}

		// store the original onNew function if there is one
		aInterfaceUtils._onNewInterface = VS.Type.getFunction('Interface', 'onNew');
		
		// the function that will be used as the `Interface.onNew` function
		const onNewInterface = function() {
			const interfaceName = this.getInterfaceName();
			if (!interfaceName) return;
			this.defaultPos = { 'x': this.xPos, 'y': this.yPos };
			this.defaultDisplay = { 'layer': this.layer, 'plane': this.plane };
			this.defaultSize = { 'width': this.width, 'height': this.height };
			this.defaultScreenPercentage = { 'x': ((100 * this.xPos) / VS.World.getGameSize().width), 'y': ((100 * this.yPos) / VS.World.getGameSize().height) };
			this.interfaceName = interfaceName;

			if (this.dragOptions.draggable) {
				if (this.dragOptions.titlebar) {
					if (!this.dragOptions.titlebar.xPos) {
						this.dragOptions.titlebar.xPos = 0;
					}

					if (!this.dragOptions.titlebar.yPos) {
						this.dragOptions.titlebar.yPos = 0;
					}
				}

				if (!this.aIntefaceUtilsonMouseEnterSet) {
					this.aIntefaceUtilsonMouseEnter = this.onMouseEnter;
					this.aIntefaceUtilsonMouseEnterSet = true;
					this.onMouseEnter = function(pClient, pX, pY) {
						if (this.dragOptions.titlebar) {
							if (this.dragOptions.titlebar.xPos >= 0 && this.dragOptions.titlebar.yPos >= 0 && this.dragOptions.titlebar.width > 0 && this.dragOptions.titlebar.height > 0) {
								const realX = this.xPos + pX;
								const realY = this.yPos + pY;
								const titleBarX = this.xPos + this.dragOptions.titlebar.xPos;
								const titleBarWidthX = titleBarX + this.dragOptions.titlebar.width;
								const titleBarY = this.yPos + this.dragOptions.titlebar.yPos;
								const titleBarHeightY = titleBarY + this.dragOptions.titlebar.height;
								if (realX >= titleBarX && realX <= titleBarWidthX && realY >= titleBarY && realY <= titleBarHeightY) {
									VS.Client.aInterfaceUtils.handleMouseOverDragArea();
								}
							}
							if (this.aIntefaceUtilsonMouseEnter) {
								this.aIntefaceUtilsonMouseEnter.apply(this, arguments);
							}
						} else if (this.dragOptions.draggable) {
							VS.Client.aInterfaceUtils.handleMouseOverDragArea();
						}
					}
				}

				if (!this.aIntefaceUtilsonMouseExitSet) {
					this.aIntefaceUtilsonMouseExit = this.onMouseExit;
					this.aIntefaceUtilsonMouseExitSet = true;
					this.onMouseExit = function(pClient, pX, pY) {
						VS.Client.aInterfaceUtils.handleMouseOverDragArea(true);
						if (this.aIntefaceUtilsonMouseExit) {
							this.aIntefaceUtilsonMouseExit.apply(this, arguments);
						}
					}
				}

				if (!this.aIntefaceUtilsonMouseMoveSet) {
					this.aIntefaceUtilsonMouseMove = this.onMouseMove;
					this.aIntefaceUtilsonMouseMoverSet = true;
					this.onMouseMove = function(pClient, pX, pY) {
						if (this.dragOptions.titlebar) {
							if (this.dragOptions.titlebar.xPos >= 0 && this.dragOptions.titlebar.yPos >= 0 && this.dragOptions.titlebar.width > 0 && this.dragOptions.titlebar.height > 0) {
								const realX = this.xPos + pX;
								const realY = this.yPos + pY;
								const titleBarX = this.xPos + this.dragOptions.titlebar.xPos;
								const titleBarWidthX = titleBarX + this.dragOptions.titlebar.width;
								const titleBarY = this.yPos + this.dragOptions.titlebar.yPos;
								const titleBarHeightY = titleBarY + this.dragOptions.titlebar.height;
								if (realX >= titleBarX && realX <= titleBarWidthX && realY >= titleBarY && realY <= titleBarHeightY) {
									VS.Client.aInterfaceUtils.handleMouseOverDragArea();
								} else {
									VS.Client.aInterfaceUtils.handleMouseOverDragArea(true);
								}
							}
							if (this.aIntefaceUtilsonMouseMove) {
								this.aIntefaceUtilsonMouseMove.apply(this, arguments);
							}
						}
					}
				}
				this.dragOptions.protrudingChildren = { 'x': { 'minPos': 0, 'maxPos': 0, 'minWidth': 0, 'maxWidth': 0 }, 'y': { 'minPos': 0, 'maxPos': 0, 'minHeight': 0, 'maxHeight': 0 }};
				this.dragOptions.clampedPos = { 'x': { 'maxPos': 0, 'minPos': 0 }, 'y': { 'maxPos': 0, 'minPos': 0 } };
				for (const element of VS.Client.getInterfaceElements(this.interfaceName)) {
					if (element.parentElement === this.name) {
						const greaterX = (element.xPos > this.xPos + this.width) && (this.dragOptions.protrudingChildren.x.maxPos ? element.xPos > this.dragOptions.protrudingChildren.x.maxPos : true);
						const lesserX = (element.xPos < this.xPos) && (this.dragOptions.protrudingChildren.x.minPos ? element.xPos < this.dragOptions.protrudingChildren.x.minPos : true);
						const greaterY = (element.yPos > this.yPos + this.height) && (this.dragOptions.protrudingChildren.y.maxPos ? element.yPos > this.dragOptions.protrudingChildren.y.maxPos : true);
						const lesserY = (element.yPos < this.yPos) && (this.dragOptions.protrudingChildren.y.minPos ? element.yPos < this.dragOptions.protrudingChildren.y.minPos : true);

						if (greaterX) {
							this.dragOptions.protrudingChildren.x.maxPos = element.xPos;
							this.dragOptions.protrudingChildren.x.maxWidth = element.width;
							this._protruding.east = true;
						} else if (lesserX) {
							this.dragOptions.protrudingChildren.x.minPos = element.xPos;
							this.dragOptions.protrudingChildren.x.minWidth = element.width;
							this._protruding.west = true;
						}
						if (greaterY) {
							this.dragOptions.protrudingChildren.y.maxPos = element.yPos;
							this.dragOptions.protrudingChildren.y.maxHeight = element.height;
							this._protruding.south = true;
						} else if (lesserY) {
							this.dragOptions.protrudingChildren.y.minPos = element.yPos;
							this.dragOptions.protrudingChildren.y.minHeight = element.height;
							this._protruding.north = true;
						}
					}
				}
			}

			if (VS.Client.aInterfaceUtils._onNewInterface) {
				VS.Client.aInterfaceUtils._onNewInterface.apply(this, arguments);
			}
		}

		// assign the custom onNew function to the Interface type
		VS.Type.setFunction('Interface', 'onNew', onNewInterface);

		// store the original onShow function if there is one
		aInterfaceUtils._onShowInterface = VS.Type.getFunction('Interface', 'onShow');
		
		// the function that will be used as the `Interface.onShow` function
		const onShowInterface = function(pClient) {
			this.shown = true;
			if (VS.Client.aInterfaceUtils._onShowInterface) {
				VS.Client.aInterfaceUtils._onShowInterface.apply(this, arguments);
			}
		}

		// assign the custom onShow function to the Interface type
		VS.Type.setFunction('Interface', 'onShow', onShowInterface);

		// store the original onHide function if there is one
		aInterfaceUtils._onHideInterface = VS.Type.getFunction('Interface', 'onHide');
		
		// the function that will be used as the `Interface.onHide` function
		const onHideInterface = function(pClient) {
			this.shown = false;
			if (VS.Client.aInterfaceUtils._onHideInterface) {
				VS.Client.aInterfaceUtils._onHideInterface.apply(this, arguments);
			}
		}
		
		// assign the custom onHide function to the Interface type
		VS.Type.setFunction('Interface', 'onHide', onHideInterface);

		const repositionInterface = function(pX, pY, pDefaultX, pDefaultY) {
			const size = {
				'width': (this.preventAutoScale ? VS.Client._windowSize.width : VS.Client._gameSize.width),
				'height': (this.preventAutoScale ? VS.Client._windowSize.height : VS.Client._gameSize.height)
			}
			const xOff = VS.Client._dragging.xOff;
			const yOff = VS.Client._dragging.yOff;
			const protrudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][this._protruding.east | (this._protruding.west << 1) | (this._protruding.north << 2) | (this._protruding.south << 3)];

			if (protrudingDirection === 'none') {
				this.setPos(Math.clamp(pX - xOff + this.defaultPos.x - pDefaultX, this.dragOptions.clampedPos.x.minPos, size.width - this.dragOptions.owner.width + this.dragOptions.clampedPos.x.minPos), Math.clamp(pY - yOff + this.defaultPos.y - pDefaultY, this.dragOptions.clampedPos.y.minPos, size.height - this.dragOptions.owner.height + this.dragOptions.clampedPos.y.minPos));
				return;
			}

			if (protrudingDirection === 'n' || protrudingDirection === 's' || protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ws' || protrudingDirection === 'sn' || protrudingDirection === 'wns') {
				this.xPos = Math.clamp(pX - xOff + this.defaultPos.x - pDefaultX, this.dragOptions.clampedPos.x.minPos, size.width - this.dragOptions.owner.width + this.dragOptions.clampedPos.x.maxPos);
			}

			if (protrudingDirection === 'e' || protrudingDirection === 'ew' || protrudingDirection === 'es' || protrudingDirection === 'en' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns' || protrudingDirection === 'ens') {
				this.xPos = Math.clamp(pX - xOff + this.defaultPos.x - pDefaultX, this.dragOptions.clampedPos.x.minPos, size.width - this.dragOptions.clampedPos.x.maxPos);
			}

			if (protrudingDirection === 'n' || protrudingDirection === 'e' || protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ew' || protrudingDirection === 'en' || protrudingDirection === 'ewn') {
				this.yPos = Math.clamp(pY - yOff + this.defaultPos.y - pDefaultY, this.dragOptions.clampedPos.y.minPos, size.height - this.dragOptions.owner.height + this.dragOptions.clampedPos.y.maxPos);
			}

			if (protrudingDirection === 's' || protrudingDirection === 'ws' || protrudingDirection === 'sn' || protrudingDirection === 'es' || protrudingDirection === 'ews' || protrudingDirection === 'ewns' || protrudingDirection === 'ens' || protrudingDirection === 'wns') {
				this.yPos = Math.clamp(pY - yOff + this.defaultPos.y - pDefaultY, this.dragOptions.clampedPos.y.minPos, size.height - this.dragOptions.clampedPos.y.maxPos);
			}
		}

		// give this reposition function to the interface type
		VS.Type.setFunction('Interface', 'reposition', repositionInterface);

		const leave = () => {
			if (VS.Client) {
				if (!aInterfaceUtils.mouseOffScreen) {
					aInterfaceUtils.mouseOffScreen = true;
					if (VS.Client._dragging) {
						if (VS.Client._dragging.element) {
							VS.Client.releaseElement();
						}
						if (VS.Client.onMouseLeave && typeof(VS.Client.onMouseLeave) === 'function') {
							VS.Client.onMouseLeave();
						}
					}
				}
				VS.Client.setMouseCursor('');
			}
		}

		const enter = () => {
			if (VS.Client) {
				if (aInterfaceUtils.mouseOffScreen) {
					aInterfaceUtils.mouseOffScreen = false;
					if (VS.Client.onMouseEnter && typeof(VS.Client.onMouseEnter) === 'function') {
						VS.Client.onMouseEnter();
					}
				}
			}
		}

		document.addEventListener('mouseleave', (pEvent) => {
			leave();
		});

		document.addEventListener('mouseenter', (pEvent) => {
			enter();
		});

		document.addEventListener('mousemove', (pEvent) => {
			if (pEvent.clientY <= 0 || pEvent.clientX <= 0 || pEvent.clientX >= window.innerWidth || pEvent.clientY >= window.innerHeight) {
				leave();
			} else if (aInterfaceUtils.mouseOffScreen) {
				enter();
			}
		});
	}

})();

#END JAVASCRIPT
#END CLIENTCODE

#BEGIN WEBSTYLE

.aInterfaceUtils_dialog {
	text-shadow: rgb(34, 34, 34) 2px 0px 0px, rgb(34, 34, 34) 1.75517px 0.958851px 0px, rgb(34, 34, 34) 1.0806px 1.68294px 0px, rgb(34, 34, 34) 0.141474px 1.99499px 0px, rgb(34, 34, 34) -0.832294px 1.81859px 0px, rgb(34, 34, 34) -1.60229px 1.19694px 0px, rgb(34, 34, 34) -1.97998px 0.28224px 0px, rgb(34, 34, 34) -1.87291px -0.701566px 0px, rgb(34, 34, 34) -1.30729px -1.5136px 0px, rgb(34, 34, 34) -0.421592px -1.95506px 0px, rgb(34, 34, 34) 0.567324px -1.91785px 0px, rgb(34, 34, 34) 1.41734px -1.41108px 0px, rgb(34, 34, 34) 1.92034px -0.558831px 0px;
	font-family: 'Arial', sans-serif;
	color: #fff;
	font-size: 12px;
	padding-top: 35px;
	text-align: center;
}

.aInterfaceUtils_dialog_button {
	text-shadow: rgb(34, 34, 34) 2px 0px 0px, rgb(34, 34, 34) 1.75517px 0.958851px 0px, rgb(34, 34, 34) 1.0806px 1.68294px 0px, rgb(34, 34, 34) 0.141474px 1.99499px 0px, rgb(34, 34, 34) -0.832294px 1.81859px 0px, rgb(34, 34, 34) -1.60229px 1.19694px 0px, rgb(34, 34, 34) -1.97998px 0.28224px 0px, rgb(34, 34, 34) -1.87291px -0.701566px 0px, rgb(34, 34, 34) -1.30729px -1.5136px 0px, rgb(34, 34, 34) -0.421592px -1.95506px 0px, rgb(34, 34, 34) 0.567324px -1.91785px 0px, rgb(34, 34, 34) 1.41734px -1.41108px 0px, rgb(34, 34, 34) 1.92034px -0.558831px 0px;
	font-family: 'Arial', sans-serif;
	color: #fff;
	font-size: 11px;
	text-align: center;
}

.aInterfaceUtils_center_title {
	text-shadow: rgb(34, 34, 34) 2px 0px 0px, rgb(34, 34, 34) 1.75517px 0.958851px 0px, rgb(34, 34, 34) 1.0806px 1.68294px 0px, rgb(34, 34, 34) 0.141474px 1.99499px 0px, rgb(34, 34, 34) -0.832294px 1.81859px 0px, rgb(34, 34, 34) -1.60229px 1.19694px 0px, rgb(34, 34, 34) -1.97998px 0.28224px 0px, rgb(34, 34, 34) -1.87291px -0.701566px 0px, rgb(34, 34, 34) -1.30729px -1.5136px 0px, rgb(34, 34, 34) -0.421592px -1.95506px 0px, rgb(34, 34, 34) 0.567324px -1.91785px 0px, rgb(34, 34, 34) 1.41734px -1.41108px 0px, rgb(34, 34, 34) 1.92034px -0.558831px 0px;
	font-family: 'Arial', sans-serif;
	color: #fff;
	font-size: 14px;
	text-align: center;
}

.aInterfaceUtils_input {
	text-shadow: rgb(34, 34, 34) 2px 0px 0px, rgb(34, 34, 34) 1.75517px 0.958851px 0px, rgb(34, 34, 34) 1.0806px 1.68294px 0px, rgb(34, 34, 34) 0.141474px 1.99499px 0px, rgb(34, 34, 34) -0.832294px 1.81859px 0px, rgb(34, 34, 34) -1.60229px 1.19694px 0px, rgb(34, 34, 34) -1.97998px 0.28224px 0px, rgb(34, 34, 34) -1.87291px -0.701566px 0px, rgb(34, 34, 34) -1.30729px -1.5136px 0px, rgb(34, 34, 34) -0.421592px -1.95506px 0px, rgb(34, 34, 34) 0.567324px -1.91785px 0px, rgb(34, 34, 34) 1.41734px -1.41108px 0px, rgb(34, 34, 34) 1.92034px -0.558831px 0px;
	font-family: 'Arial', sans-serif;
	color: #fff;
	font-size: 12px;
	padding-top: 18px;
	padding-left: 6px;
}

.aInterfaceUtils_bold {
	font-weight: bold;
}

#ti_aInterfaceUtils_input_interface_input_menu_input::placeholder {
  color: #ffffff;
  opacity: 0.5;
}

#END WEBSTYLE

#ENABLE LOCALCLIENTCODE
#BEGIN CLIENTCODE
#BEGIN JAVASCRIPT

(() => {
	const aInterfaceUtils = {};
	let libraryBuilt = false;
	const engineWaitId = setInterval(() => {
		if (VS.World.global && !libraryBuilt) {
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
							VS.World.global.aInterfaceUtils.inInput = false;
							/* this.setMacroAtlas(this.getInterfaceElement('aInterfaceUtils_input_interface', 'input_menu').storedMacroAtlas); */
							this.setFocus();
						}
					}
				}
				if (VS.World.global.aInterfaceUtils._onMouseClick) {
					VS.World.global.aInterfaceUtils._onMouseClick.apply(this, arguments);
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
			VS.World.global.aInterfaceUtils.closeAlertMenu();
		});
		VS.Client.addCommand('leftArrowSelectAlert', function() {

		});
		VS.Client.addCommand('rightArrowSelectAlert', rightArrowSelectAlert = function() {
			
		});
		// input
		VS.Client.addCommand('closeInputMenu', function() {
			VS.World.global.aInterfaceUtils.closeInputMenu();
		});
		VS.Client.addCommand('leftArrowSelectInput', function() {

		});
		VS.Client.addCommand('rightArrowSelectInput', function() {
			
		});
		// confirm
		VS.Client.addCommand('closeConfirmMenu', function() {
			VS.World.global.aInterfaceUtils.closeConfirmMenu();
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
					VS.World.global.aInterfaceUtils.alert(alertMenu.queuedAlerts['message' + count], alertMenu.queuedAlerts['title' + count], alertMenu.queuedAlerts['callback' + count], alertMenu.queuedAlerts['parameters' + count]);
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
					VS.World.global.aInterfaceUtils.input(inputMenu.queuedInputs['text' + count], inputMenu.queuedInputs['defaultText' + count], inputMenu.queuedInputs['numbersOnly' + count], inputMenu.queuedInputs['callback' + count], inputMenu.queuedInputs['parameters' + count]);
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
					VS.World.global.aInterfaceUtils.confirm(confirmMenu.queuedDialogs['message' + count], confirmMenu.queuedDialogs['title' + count], confirmMenu.queuedDialogs['callback' + count], confirmMenu.queuedDialogs['parameters' + count]);
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

		// store the original onConnect function if there is one
		aInterfaceUtils._onConnect = VS.Type.getFunction('Client', 'onConnect');

		const isMousedDown = function() {
			if (VS.Client._mousedDowned === this) {
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

		// the function that will be used as the `pClient.onConnect` function
		const onConnect = function() {
			this._screenScale = { 'x': 1, 'y': 1 };
			this._windowSize = this.getWindowSize();
			this._gameSize = VS.World.getGameSize();
			this.getScreenScale(this._screenScale);
			this._dragging = { 'element': null, 'xOff': 0, 'yOff': 0 };
			this._mousedDowned = null;
			this.dragging = false;
			if (VS.World.global.aInterfaceUtils._onConnect) {
				VS.World.global.aInterfaceUtils._onConnect.apply(this);
			}
		}

		// assign the custom onConnect function to the client
		VS.Type.setFunction('Client', 'onConnect', onConnect);

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
			if (VS.World.global.aInterfaceUtils._onWindowResize) {
				VS.World.global.aInterfaceUtils._onWindowResize.apply(this, arguments);
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

			for (const e of this.getInterfaceElements(pInterface)) {
				if (protruding) {
					e._protruding = protruding;
					protrudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][e._protruding.east | (e._protruding.west << 1) | (e._protruding.north << 2) | (e._protruding.south << 3)];
				}

				if (e.dragOptions.draggable && e.dragOptions.parent) {
					if (protrudingDirection === 'none') {
						e.dragOptions.offsets = { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } };
						continue;
					}

					if (protrudingDirection === 'e' || protrudingDirection === 'en' || protrudingDirection === 'es' || protrudingDirection === 'ens') {
						e.dragOptions.offsets.x = { 'max': e.dragOptions.freeze.x.max - e.xPos - e.width + e.dragOptions.freeze.x.maxWidth, 'min': 0 };
					}

					if (protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ws' || protrudingDirection === 'wns') {
						e.dragOptions.offsets.x = { 'max': 0, 'min': e.xPos - e.dragOptions.freeze.x.min };
					}

					if (protrudingDirection === 'ew' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns') {
						e.dragOptions.offsets.x = { 'max': e.dragOptions.freeze.x.max - e.xPos - e.width + e.dragOptions.freeze.x.maxWidth, 'min': e.xPos - e.dragOptions.freeze.x.min };
					}

					if (protrudingDirection === 'n' || protrudingDirection === 'en' || protrudingDirection === 'wn' || protrudingDirection === 'ewn') {
						e.dragOptions.offsets.y = { 'max': 0, 'min': e.yPos - e.dragOptions.freeze.y.min };
					}

					if (protrudingDirection === 's' || protrudingDirection === 'es' || protrudingDirection === 'ws' || protrudingDirection === 'ews') {
						e.dragOptions.offsets.y = { 'max': e.dragOptions.freeze.y.max - e.yPos - e.height + e.dragOptions.freeze.y.maxHeight, 'min': 0 };
					}

					if (protrudingDirection === 'sn' || protrudingDirection === 'ens' || protrudingDirection === 'wns' || protrudingDirection === 'ewns') {
						e.dragOptions.offsets.y = { 'max': e.dragOptions.freeze.y.max - e.yPos - e.height + e.dragOptions.freeze.y.maxHeight, 'min': e.yPos - e.dragOptions.freeze.y.min };
					}
					continue;
				}

				if (e.parentElement) {
					const parent = this.getInterfaceElement(pInterface, e.parentElement);
					const noneX = Math.sign(e.xPos - parent.xPos) === -1 ? 0 : e.xPos - parent.xPos;
					const noneY = Math.sign(e.yPos - parent.yPos) === -1 ? 0 : e.yPos - parent.yPos;
					e.dragOptions.owner = parent;

					if (protrudingDirection === 'none') {
						e.dragOptions.offsets.x.max = Math.sign(e.xPos - parent.xPos) === -1 ? 0 : e.xPos - parent.xPos;
						e.dragOptions.offsets.x.min = e.dragOptions.offsets.x.max;
						e.dragOptions.offsets.y.max = Math.sign(e.yPos - parent.yPos) === -1 ? 0 : e.yPos - parent.yPos;
						e.dragOptions.offsets.y.min = e.dragOptions.offsets.y.max;
						continue;
					}

					if (protrudingDirection === 'n' || protrudingDirection === 's' || protrudingDirection === 'sn') {
						e.dragOptions.offsets.x = { 'max': noneX, 'min': noneX };
					}

					if (protrudingDirection === 'e' || protrudingDirection === 'es' || protrudingDirection === 'en' || protrudingDirection === 'ens') {
						e.dragOptions.offsets.x = { 'max': parent.dragOptions.freeze.x.max - e.xPos + e.width, 'min': noneX };
					}

					if (protrudingDirection === 'w' || protrudingDirection === 'ws' || protrudingDirection === 'wns' || protrudingDirection === 'wn') {
						e.dragOptions.offsets.x = { 'max': e.xPos - parent.xPos, 'min': e.xPos - parent.dragOptions.freeze.x.min };
					}

					if (protrudingDirection === 'ew' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns') {
						e.dragOptions.offsets.x = { 'max': parent.dragOptions.freeze.x.max - e.xPos + e.width, 'min': e.xPos - parent.dragOptions.freeze.x.min };
					}

					if (protrudingDirection === 'n' || protrudingDirection === 'wn' || protrudingDirection === 'en' || protrudingDirection === 'ewn') {
						e.dragOptions.offsets.y = { 'max': e.yPos - parent.yPos, 'min': e.yPos - parent.dragOptions.freeze.y.min };
					}

					if (protrudingDirection === 's' || protrudingDirection === 'ws' || protrudingDirection === 'es' || protrudingDirection === 'ews') {
						e.dragOptions.offsets.y = { 'max': parent.dragOptions.freeze.y.max - e.yPos + e.height, 'min': noneY };
					}

					if (protrudingDirection === 'e' || protrudingDirection === 'w' || protrudingDirection === 'ew') {
						e.dragOptions.offsets.y = { 'max': noneY, 'min': noneY };
					}

					if (protrudingDirection === 'sn' || protrudingDirection === 'ens' || protrudingDirection === 'wns' || protrudingDirection === 'ewns') {
						e.dragOptions.offsets.y = { 'max': parent.dragOptions.freeze.y.max - e.yPos + e.height, 'min': e.yPos - parent.dragOptions.freeze.y.min };
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
				const MAX_PLANE = 999999;
				let realX = (this._dragging.element.preventAutoScale ? pX * this._screenScale.x : pX) - this._dragging.xOff;
				let realY = (this._dragging.element.preventAutoScale ? pY * this._screenScale.y : pY) - this._dragging.yOff;
				let maxWidth;
				let maxHeight;

				if (this._dragging.element.dragOptions?.titlebar?.xPos >= 0 && this._dragging.element.dragOptions?.titlebar?.yPos >= 0 && this._dragging.element.dragOptions?.titlebar?.width > 0 && this._dragging.element.dragOptions?.titlebar?.height > 0) {
					const titleBarX = this._dragging.element.xPos + this._dragging.element.dragOptions.titlebar.xPos;
					const titleBarWidthX = titleBarX + this._dragging.element.dragOptions.titlebar.width;
					const titleBarY = this._dragging.element.yPos + this._dragging.element.dragOptions.titlebar.yPos;
					const titleBarHeightY = titleBarY + this._dragging.element.dragOptions.titlebar.height;
					maxWidth = (this._dragging.element.preventAutoScale ? this._windowSize.width : this._gameSize.width) - this._dragging.element.width;
					maxHeight = (this._dragging.element.preventAutoScale ? this._windowSize.height : this._gameSize.height) - this._dragging.element.height;
				} else {
					maxWidth = (this._dragging.element.preventAutoScale ? this._windowSize.width : this._gameSize.width) - this._dragging.element.width;
					maxHeight = (this._dragging.element.preventAutoScale ? this._windowSize.height : this._gameSize.height) - this._dragging.element.height;
				}

				this._dragging.element.setPos(Math.clamp(realX, this._dragging.element.dragOptions.offsets.x.min, maxWidth - this._dragging.element.dragOptions.offsets.x.max), Math.clamp(realY, this._dragging.element.dragOptions.offsets.y.min, maxHeight - this._dragging.element.dragOptions.offsets.y.max));

				if (this._dragging.element.onMove) {
					this._dragging.element.onMove(this._dragging.element.xPos, this._dragging.element.yPos);
				}

				if (this._dragging.element.dragOptions.parent) {
					realX += this._dragging.xOff;
					realY += this._dragging.yOff;

					for (const e of this.getInterfaceElements(this._dragging.element.interfaceName)) {
						if (e !== this._dragging.element) {
							if (e.parentElement === this._dragging.element.name) {
								e.reposition(realX, realY, this._dragging.element.defaultPos.x, this._dragging.element.defaultPos.y);
								if (e.onMove) {
									e.onMove(e.xPos, e.yPos);
								}
							}
						}
					}
				}

				if (this._dragging.element.dragOptions.beingDragged) {
					return;
				}

				this._dragging.element.dragOptions.beingDragged = true;

				if (this._dragging.element.onDragStart) {
					this._dragging.element.onDragStart(this._dragging.element.xPos, this._dragging.element.yPos);
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
							if (childElem.onDragStart) {
								childElem.onDragStart();
							}
						}
					}
				}
			}

			if (VS.World.global.aInterfaceUtils._onMouseMove) {
				VS.World.global.aInterfaceUtils._onMouseMove.apply(this, arguments);
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
								this.dragging = true;
							}
							return;
						}

						this._dragging.element = pDiob;
						this._dragging.xOff = realX - pDiob.xPos;
						this._dragging.yOff = realY - pDiob.yPos;
						this.dragging = true;
					}
				}
			}
			if (VS.World.global.aInterfaceUtils._onMouseDown) {
				VS.World.global.aInterfaceUtils._onMouseDown.apply(this, arguments);
			}
		}

		// assign the custom onMouseDown function to the client
		VS.Type.setFunction('Client', 'onMouseDown', onMouseDown);

		// store the original onMouseUp function if there is one
		aInterfaceUtils._onMouseUp = VS.Type.getFunction('Client', 'onMouseUp');

		// the function that will be used as the `pClient.onMouseUp` function
		const onMouseUp = function(pDiob, pX, pY, pButton) {
			if (pButton === 1) {
				if (this._dragging.element) {
					const MAX_PLANE = 999999;
					if (this._dragging.element.dragOptions.beingDragged) {
						const realX = (this._dragging.element.preventAutoScale ? pX * this._screenScale.x : pX);
						const realY = (this._dragging.element.preventAutoScale ? pY * this._screenScale.y : pY);
						
						if (this._dragging.element.onDragEnd) {
							this._dragging.element.onDragEnd(this._dragging.element.xPos, this._dragging.element.yPos);
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
									if (childElem.onDragEnd) {
										childElem.onDragEnd();
									}
								}
							}
						}

						this._dragging.element.dragOptions.beingDragged = false;
						this._dragging.element = null;
						this.dragging = false;
						return;
					}
				}

				this._dragging.element = null;
				this.dragging = false;
			}

			if (VS.World.global.aInterfaceUtils._onMouseUp) {
				VS.World.global.aInterfaceUtils._onMouseUp.apply(this, arguments);
			}
		}

		// assign the custom onMouseUp function to the client
		VS.Type.setFunction('Client', 'onMouseUp', onMouseUp);
		VS.Type.setVariables('Interface', { 'scale': { 'x': 1, 'y': 1 }, 'anchor': { 'x': 0.5, 'y': 0.5 }, '_protruding': { 'east': false, 'west': false, 'north': false, 'south': false }, 'dragOptions': { 'draggable': false, 'beingDragged': false, 'parent': false, 'offsets': { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }, 'titlebar': { 'width': 0, 'height': 0, 'xPos': 0, 'yPos': 0 } } })

		// store the original onNew function if there is one
		aInterfaceUtils._onNew = VS.Type.getFunction('Interface', 'onNew');
		
		// the function that will be used as the `Interface.onNew` function
		const onNew = function() {
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
				this.dragOptions.freeze = { 'x': { 'min': 0, 'max': 0, 'minWidth': 0, 'maxWidth': 0 }, 'y': { 'min': 0, 'max': 0, 'minHeight': 0, 'maxHeight': 0 }, 'updateX': false, 'updateX2': false, 'updateY': false, 'updateY2': false };
				this.dragOptions.offsets = { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } };
				for (const e of VS.Client.getInterfaceElements(this.interfaceName)) {
					if (e.parentElement === this.name) {
						const greaterX = (e.xPos > this.xPos + this.width) && (this.dragOptions.freeze.x.max ? e.xPos > this.dragOptions.freeze.x.max : true);
						const lesserX = (e.xPos < this.xPos) && (this.dragOptions.freeze.x.min ? e.xPos < this.dragOptions.freeze.x.min : true);
						const greaterY = (e.yPos > this.yPos + this.height) && (this.dragOptions.freeze.y.max ? e.yPos > this.dragOptions.freeze.y.max : true);
						const lesserY = (e.yPos < this.yPos) && (this.dragOptions.freeze.y.min ? e.yPos < this.dragOptions.freeze.y.min : true);

						if (greaterX) {
							this.dragOptions.freeze.updateX2 = true;
							this.dragOptions.freeze.x.max = e.xPos;
							this.dragOptions.freeze.x.maxWidth = e.width;
							this._protruding.east = true;
						} else if (lesserX) {
							this.dragOptions.freeze.updateX = true;
							this.dragOptions.freeze.x.min = e.xPos;
							this.dragOptions.freeze.x.minWidth = e.width;
							this._protruding.west = true;
						}
						if (greaterY) {
							this.dragOptions.freeze.updateY2 = true;
							this.dragOptions.freeze.y.max = e.yPos;
							this.dragOptions.freeze.y.maxHeight = e.height;
							this._protruding.south = true;
						} else if (lesserY) {
							this.dragOptions.freeze.updateY = true;
							this.dragOptions.freeze.y.min = e.yPos;
							this.dragOptions.freeze.y.minHeight = e.height;
							this._protruding.north = true;
						}
					}
				}
			}

			if (VS.World.global.aInterfaceUtils._onNew) {
				VS.World.global.aInterfaceUtils._onNew.apply(this, arguments);
			}
		}

		// assign the custom onShow function to the Interface type
		VS.Type.setFunction('Interface', 'onNew', onNew);

		// store the original onShow function if there is one
		aInterfaceUtils._onShow = VS.Type.getFunction('Interface', 'onShow');
		
		// the function that will be used as the `Interface.onShow` function
		const onShow = function(pClient) {
			this.shown = true;
			if (VS.World.global.aInterfaceUtils._onShow) {
				VS.World.global.aInterfaceUtils._onShow.apply(this, arguments);
			}
		}

		// assign the custom onShow function to the Interface type
		VS.Type.setFunction('Interface', 'onShow', onShow);

		// store the original onHide function if there is one
		aInterfaceUtils._onHide = VS.Type.getFunction('Interface', 'onHide');
		
		// the function that will be used as the `Interface.onHide` function
		const onHide = function(pClient) {
			this.shown = false;
			if (VS.World.global.aInterfaceUtils._onHide) {
				VS.World.global.aInterfaceUtils._onHide.apply(this, arguments);
			}
		}
		
		// assign the custom onHide function to the Interface type
		VS.Type.setFunction('Interface', 'onHide', onHide);

		const reposition = function(pX, pY, pDefaultX, pDefaultY) {
			const size = {
				'width': (this.preventAutoScale ? VS.Client._windowSize.width : VS.Client._gameSize.width),
				'height': (this.preventAutoScale ? VS.Client._windowSize.height : VS.Client._gameSize.height)
			}
			const xOff = VS.Client._dragging.xOff;
			const yOff = VS.Client._dragging.yOff;
			const protrudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][this._protruding.east | (this._protruding.west << 1) | (this._protruding.north << 2) | (this._protruding.south << 3)];

			if (protrudingDirection === 'none') {
				this.setPos(Math.clamp(pX - xOff + this.defaultPos.x - pDefaultX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.owner.width + this.dragOptions.offsets.x.min), Math.clamp(pY - yOff + this.defaultPos.y - pDefaultY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.owner.height + this.dragOptions.offsets.y.min));
				return;
			}

			if (protrudingDirection === 'n' || protrudingDirection === 's' || protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ws' || protrudingDirection === 'sn' || protrudingDirection === 'wns') {
				this.xPos = Math.clamp(pX - xOff + this.defaultPos.x - pDefaultX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.owner.width + this.dragOptions.offsets.x.max);
			}

			if (protrudingDirection === 'e' || protrudingDirection === 'ew' || protrudingDirection === 'es' || protrudingDirection === 'en' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns' || protrudingDirection === 'ens') {
				this.xPos = Math.clamp(pX - xOff + this.defaultPos.x - pDefaultX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.offsets.x.max);
			}

			if (protrudingDirection === 'n' || protrudingDirection === 'e' || protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ew' || protrudingDirection === 'en' || protrudingDirection === 'ewn') {
				this.yPos = Math.clamp(pY - yOff + this.defaultPos.y - pDefaultY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.owner.height + this.dragOptions.offsets.y.max);
			}

			if (protrudingDirection === 's' || protrudingDirection === 'ws' || protrudingDirection === 'sn' || protrudingDirection === 'es' || protrudingDirection === 'ews' || protrudingDirection === 'ewns' || protrudingDirection === 'ens' || protrudingDirection === 'wns') {
				this.yPos = Math.clamp(pY - yOff + this.defaultPos.y - pDefaultY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.offsets.y.max);
			}
		}

		// give this reposition function to the interface type
		VS.Type.setFunction('Interface', 'reposition', reposition);
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

#DEFINE MAX_PLANE 999999

#ENABLE LOCALCLIENTCODE
#BEGIN CLIENTCODE

Client
	var _windowSize
	var _gameSize
	var _screenScale = { 'x': 1, 'y': 1 }
	var _dragging = { 'element': null, 'xOff': 0, 'yOff': 0 }
	var _mousedDowned
	// a var to check if the client is dragging something around currently READ ONLY
	var dragging

	onNew()
		this._windowSize = this.getWindowSize()
		this._gameSize = World.getGameSize()
		this.getScreenScale(this._screenScale)
		this.___EVITCA_aInterfaceUtils = true

	onWindowResize(pWidth, pHeight)
		this._windowSize.width = pWidth
		this._windowSize.height = pHeight
		this.getScreenScale(this._screenScale)

	onInterfaceLoaded(pInterface)
		var protruding
		foreach (var x in this.getInterfaceElements(pInterface))
			if (x.dragOptions.draggable && x.dragOptions.parent)
				protruding = x._protruding

		foreach (var e in this.getInterfaceElements(pInterface))
			if (protruding)
				e._protruding = protruding
				var protrudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][e._protruding.east | (e._protruding.west << 1) | (e._protruding.north << 2) | (e._protruding.south << 3)]

			if (e.dragOptions.draggable && e.dragOptions.parent)
				if (protrudingDirection === 'none')
					e.dragOptions.offsets = { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }
					continue

				if (protrudingDirection === 'e' || protrudingDirection === 'en' || protrudingDirection === 'es' || protrudingDirection === 'ens')
					e.dragOptions.offsets.x = { 'max': e.dragOptions.freeze.x.max - e.xPos - e.width + e.dragOptions.freeze.x.maxWidth, 'min': 0 }

				if (protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ws' || protrudingDirection === 'wns')
					e.dragOptions.offsets.x = { 'max': 0, 'min': e.xPos - e.dragOptions.freeze.x.min }

				if (protrudingDirection === 'ew' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns')
					e.dragOptions.offsets.x = { 'max': e.dragOptions.freeze.x.max - e.xPos - e.width + e.dragOptions.freeze.x.maxWidth, 'min': e.xPos - e.dragOptions.freeze.x.min }

				if (protrudingDirection === 'n' || protrudingDirection === 'en' || protrudingDirection === 'wn' || protrudingDirection === 'ewn')
					e.dragOptions.offsets.y = { 'max': 0, 'min': e.yPos - e.dragOptions.freeze.y.min }

				if (protrudingDirection === 's' || protrudingDirection === 'es' || protrudingDirection === 'ws' || protrudingDirection === 'ews')
					e.dragOptions.offsets.y = { 'max': e.dragOptions.freeze.y.max - e.yPos - e.height + e.dragOptions.freeze.y.maxHeight, 'min': 0 }

				if (protrudingDirection === 'sn' || protrudingDirection === 'ens' || protrudingDirection === 'wns' || protrudingDirection === 'ewns')
					e.dragOptions.offsets.y = { 'max': e.dragOptions.freeze.y.max - e.yPos - e.height + e.dragOptions.freeze.y.maxHeight, 'min': e.yPos - e.dragOptions.freeze.y.min }
				continue

			if (e.parentElement)
				var parent = this.getInterfaceElement(pInterface, e.parentElement)
				var noneX = Math.sign(e.xPos - parent.xPos) === -1 ? 0 : e.xPos - parent.xPos
				var noneY = Math.sign(e.yPos - parent.yPos) === -1 ? 0 : e.yPos - parent.yPos
				e.dragOptions.owner = parent

				if (protrudingDirection === 'none')
					e.dragOptions.offsets.x.max = Math.sign(e.xPos - parent.xPos) === -1 ? 0 : e.xPos - parent.xPos
					e.dragOptions.offsets.x.min = e.dragOptions.offsets.x.max
					e.dragOptions.offsets.y.max = Math.sign(e.yPos - parent.yPos) === -1 ? 0 : e.yPos - parent.yPos
					e.dragOptions.offsets.y.min = e.dragOptions.offsets.y.max
					continue

				if (protrudingDirection === 'n' || protrudingDirection === 's' || protrudingDirection === 'sn')
					e.dragOptions.offsets.x = { 'max': noneX, 'min': noneX }

				if (protrudingDirection === 'e' || protrudingDirection === 'es' || protrudingDirection === 'en' || protrudingDirection === 'ens')
					e.dragOptions.offsets.x = { 'max': parent.dragOptions.freeze.x.max - e.xPos + e.width, 'min': noneX }

				if (protrudingDirection === 'w' || protrudingDirection === 'ws' || protrudingDirection === 'wns' || protrudingDirection === 'wn')
					e.dragOptions.offsets.x = { 'max': e.xPos - parent.xPos, 'min': e.xPos - parent.dragOptions.freeze.x.min }

				if (protrudingDirection === 'ew' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns')
					e.dragOptions.offsets.x = { 'max': parent.dragOptions.freeze.x.max - e.xPos + e.width, 'min': e.xPos - parent.dragOptions.freeze.x.min }

				if (protrudingDirection === 'n' || protrudingDirection === 'wn' || protrudingDirection === 'en' || protrudingDirection === 'ewn')
					e.dragOptions.offsets.y = { 'max': e.yPos - parent.yPos, 'min': e.yPos - parent.dragOptions.freeze.y.min }

				if (protrudingDirection === 's' || protrudingDirection === 'ws' || protrudingDirection === 'es' || protrudingDirection === 'ews')
					e.dragOptions.offsets.y = { 'max': parent.dragOptions.freeze.y.max - e.yPos + e.height, 'min': noneY }

				if (protrudingDirection === 'e' || protrudingDirection === 'w' || protrudingDirection === 'ew')
					e.dragOptions.offsets.y = { 'max': noneY, 'min': noneY }

				if (protrudingDirection === 'sn' || protrudingDirection === 'ens' || protrudingDirection === 'wns' || protrudingDirection === 'ewns')
					e.dragOptions.offsets.y = { 'max': parent.dragOptions.freeze.y.max - e.yPos + e.height, 'min': e.yPos - parent.dragOptions.freeze.y.min }

	onMouseMove(pDiob, pX, pY)
		if (this._dragging.element)
			var realX = (this._dragging.element.preventAutoScale ? pX * this._screenScale.x : pX) - this._dragging.xOff
			var realY = (this._dragging.element.preventAutoScale ? pY * this._screenScale.y : pY) - this._dragging.yOff

			if (this._dragging.element.dragOptions?.titlebar?.xPos >= 0 && this._dragging.element.dragOptions?.titlebar?.yPos >= 0 && this._dragging.element.dragOptions?.titlebar?.width > 0 && this._dragging.element.dragOptions?.titlebar?.height > 0)
				var titleBarX = this._dragging.element.xPos + this._dragging.element.dragOptions.titlebar.xPos
				var titleBarWidthX = titleBarX + this._dragging.element.dragOptions.titlebar.width
				var titleBarY = this._dragging.element.yPos + this._dragging.element.dragOptions.titlebar.yPos
				var titleBarHeightY = titleBarY + this._dragging.element.dragOptions.titlebar.height
				var maxWidth = (this._dragging.element.preventAutoScale ? this._windowSize.width : this._gameSize.width) - this._dragging.element.width
				var maxHeight = (this._dragging.element.preventAutoScale ? this._windowSize.height : this._gameSize.height) - this._dragging.element.height
			else
				var maxWidth = (this._dragging.element.preventAutoScale ? this._windowSize.width : this._gameSize.width) - this._dragging.element.width
				var maxHeight = (this._dragging.element.preventAutoScale ? this._windowSize.height : this._gameSize.height) - this._dragging.element.height

			this._dragging.element.setPos(Math.clamp(realX, this._dragging.element.dragOptions.offsets.x.min, maxWidth - this._dragging.element.dragOptions.offsets.x.max), Math.clamp(realY, this._dragging.element.dragOptions.offsets.y.min, maxHeight - this._dragging.element.dragOptions.offsets.y.max))

			if (this._dragging.element.onMove)
				this._dragging.element.onMove(this._dragging.element.xPos, this._dragging.element.yPos)

			if (this._dragging.element.dragOptions.parent)
				realX += this._dragging.xOff
				realY += this._dragging.yOff
				
				foreach (var e in this.getInterfaceElements(this._dragging.element.interfaceName))
					if (e !== this._dragging.element)
						if (e.parentElement === this._dragging.element.name)
							e.reposition(realX, realY, this._dragging.element.defaultPos.x, this._dragging.element.defaultPos.y)
							if (e.onMove)
								e.onMove(e.xPos, e.yPos)

			if (this._dragging.element.dragOptions.beingDragged)
				return

			this._dragging.element.dragOptions.beingDragged = true
			// automatically dynamically relayer this element when dragging it so its above everything else
			if (this._dragging.element.onDragStart)
				this._dragging.element.onDragStart(this._dragging.element.xPos, this._dragging.element.yPos)

			foreach (var childElem in this.getInterfaceElements(this._dragging.element.interfaceName))
				if (childElem.parentElement === this._dragging.element.name || childElem === this._dragging.element)
					childElem.plane += MAX_PLANE
					childElem.layer += MAX_PLANE
					if (childElem.onDragStart)
						childElem.onDragStart()

	onMouseDown(pDiob, pX, pY, pButton)
		if (pButton === 1)
			this._mousedDowned = pDiob
			if (pDiob.baseType === 'Interface')
				if (pDiob.dragOptions.draggable)
					var realX = (pDiob.preventAutoScale ? pX * this._screenScale.x : pX)
					var realY = (pDiob.preventAutoScale ? pY * this._screenScale.y : pY)
					if (pDiob.dragOptions?.titlebar?.xPos >= 0 && pDiob.dragOptions?.titlebar?.yPos >= 0 && pDiob.dragOptions?.titlebar?.width > 0 && pDiob.dragOptions?.titlebar?.height > 0)
						var titleBarX = pDiob.xPos + pDiob.dragOptions.titlebar.xPos
						var titleBarWidthX = titleBarX + pDiob.dragOptions.titlebar.width
						var titleBarY = pDiob.yPos + pDiob.dragOptions.titlebar.yPos
						var titleBarHeightY = titleBarY + pDiob.dragOptions.titlebar.height
						if (realX >= titleBarX && realX <= titleBarWidthX && realY >= titleBarY && realY <= titleBarHeightY)
							this._dragging.element = pDiob
							this._dragging.xOff = realX - titleBarX + pDiob.dragOptions.titlebar.xPos
							this._dragging.yOff = realY - titleBarY + pDiob.dragOptions.titlebar.yPos
							this.dragging = true
						return

					this._dragging.element = pDiob
					this._dragging.xOff = realX - pDiob.xPos
					this._dragging.yOff = realY - pDiob.yPos
					this.dragging = true

	onMouseUp(pDiob, pX, pY, pButton)
		if (pButton === 1)
			if (this._dragging.element)
				if (this._dragging.element.dragOptions.beingDragged)
					var realX = (this._dragging.element.preventAutoScale ? pX * this._screenScale.x : pX)
					var realY = (this._dragging.element.preventAutoScale ? pY * this._screenScale.y : pY)
					
					if (this._dragging.element.onDragEnd)
						this._dragging.element.onDragEnd(this._dragging.element.xPos, this._dragging.element.yPos)

					foreach (var childElem in this.getInterfaceElements(this._dragging.element.interfaceName))
						if (childElem.parentElement === this._dragging.element.name || childElem === this._dragging.element)
							childElem.plane -= MAX_PLANE
							childElem.layer -= MAX_PLANE
							if (childElem.onDragEnd)
								childElem.onDragEnd()

					this._dragging.element.dragOptions.beingDragged = false
					this._dragging.element = null
					this.dragging = false
					return

			this._dragging.element = null
			this.dragging = false

Interface
	var parentElement
	var dragOptions = { 'draggable': false, 'beingDragged': false, 'parent': false, 'offsets': { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }, 'titlebar': { 'width': 0, 'height': 0, 'xPos': 0, 'yPos': 0 } }
	var _protruding = { 'east': false, 'west': false, 'north': false, 'south': false }
	var defaultPos = {}
	var defaultDisplay
	var defaultSize
	var defaultScreenPercentage = { 'x': 0, 'y': 0 }
	var interfaceName
	scale = { 'x': 1, 'y': 1 }
	anchor = 0.5

	onNew()
		this.defaultPos = { 'x': this.xPos, 'y': this.yPos }
		this.defaultDisplay = { 'layer': this.layer, 'plane': this.plane }
		this.defaultSize = { 'width': this.width, 'height': this.height }
		this.defaultScreenPercentage = { 'x': ((100 * this.xPos) / Client._gameSize.width), 'y': ((100 * this.yPos) / Client._gameSize.height) }
		this.interfaceName = this.getInterfaceName()

		if (this.dragOptions.titlebar)
			if (!this.dragOptions.titlebar.xPos)
				this.dragOptions.titlebar.xPos = 0

			if (!this.dragOptions.titlebar.yPos)
				this.dragOptions.titlebar.yPos = 0

		if (this.dragOptions.draggable)
			this.dragOptions.freeze = { 'x': { 'min': 0, 'max': 0, 'minWidth': 0, 'maxWidth': 0 }, 'y': { 'min': 0, 'max': 0, 'minHeight': 0, 'maxHeight': 0 }, 'updateX': false, 'updateX2': false, 'updateY': false, 'updateY2': false }
			this.dragOptions.offsets = { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }
			foreach (var e in Client.getInterfaceElements(this.interfaceName))
				if (e.parentElement === this.name)
					var greaterX = (e.xPos > this.xPos + this.width) && (this.dragOptions.freeze.x.max ? e.xPos > this.dragOptions.freeze.x.max : true)
					var lesserX = (e.xPos < this.xPos) && (this.dragOptions.freeze.x.min ? e.xPos < this.dragOptions.freeze.x.min : true)
					var greaterY = (e.yPos > this.yPos + this.height) && (this.dragOptions.freeze.y.max ? e.yPos > this.dragOptions.freeze.y.max : true)
					var lesserY = (e.yPos < this.yPos) && (this.dragOptions.freeze.y.min ? e.yPos < this.dragOptions.freeze.y.min : true)

					if (greaterX)
						this.dragOptions.freeze.updateX2 = true
						this.dragOptions.freeze.x.max = e.xPos
						this.dragOptions.freeze.x.maxWidth = e.width
						this._protruding.east = true

					else if (lesserX)
						this.dragOptions.freeze.updateX = true
						this.dragOptions.freeze.x.min = e.xPos
						this.dragOptions.freeze.x.minWidth = e.width
						this._protruding.west = true

					if (greaterY)
						this.dragOptions.freeze.updateY2 = true
						this.dragOptions.freeze.y.max = e.yPos
						this.dragOptions.freeze.y.maxHeight = e.height
						this._protruding.south = true

					else if (lesserY)
						this.dragOptions.freeze.updateY = true
						this.dragOptions.freeze.y.min = e.yPos
						this.dragOptions.freeze.y.minHeight = e.height
						this._protruding.north = true

	// function onDragStart()
		//...

	// function onDragEnd(pX, pY)	
		// ... 

	// function onMove(pX, pY)
		// ...

	function isMousedDown()
		if (Client._mousedDowned === this)
			return true
		return false

	function reposition(pX, pY, defaultX, defaultY)
		var size = {
			'width': (this.preventAutoScale ? Client._windowSize.width : Client._gameSize.width),
			'height': (this.preventAutoScale ? Client._windowSize.height : Client._gameSize.height)
		}
		var xOff = Client._dragging.xOff
		var yOff = Client._dragging.yOff
		var protrudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][this._protruding.east | (this._protruding.west << 1) | (this._protruding.north << 2) | (this._protruding.south << 3)]

		if (protrudingDirection === 'none')
			this.setPos(Math.clamp(pX - xOff + this.defaultPos.x - defaultX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.owner.width + this.dragOptions.offsets.x.min), Math.clamp(pY - yOff + this.defaultPos.y - defaultY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.owner.height + this.dragOptions.offsets.y.min))
			return

		if (protrudingDirection === 'n' || protrudingDirection === 's' || protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ws' || protrudingDirection === 'sn' || protrudingDirection === 'wns')
			this.xPos = Math.clamp(pX - xOff + this.defaultPos.x - defaultX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.owner.width + this.dragOptions.offsets.x.max)

		if (protrudingDirection === 'e' || protrudingDirection === 'ew' || protrudingDirection === 'es' || protrudingDirection === 'en' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns' || protrudingDirection === 'ens')
			this.xPos = Math.clamp(pX - xOff + this.defaultPos.x - defaultX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.offsets.x.max)

		if (protrudingDirection === 'n' || protrudingDirection === 'e' || protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ew' || protrudingDirection === 'en' || protrudingDirection === 'ewn')
			this.yPos = Math.clamp(pY - yOff + this.defaultPos.y - defaultY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.owner.height + this.dragOptions.offsets.y.max)

		if (protrudingDirection === 's' || protrudingDirection === 'ws' || protrudingDirection === 'sn' || protrudingDirection === 'es' || protrudingDirection === 'ews' || protrudingDirection === 'ewns' || protrudingDirection === 'ens' || protrudingDirection === 'wns')
			this.yPos = Math.clamp(pY - yOff + this.defaultPos.y - defaultY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.offsets.y.max)

#END CLIENTCODE

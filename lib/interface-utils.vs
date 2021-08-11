#ENABLE LOCALCLIENTCODE
#BEGIN CLIENTCODE

Client
	var ___windowSize = { 'width': 0, 'height': 0 }
	var ___screenScale = { 'x': 1, 'y': 1 }
	var ___dragging = { 'element': null, 'xOff': 0, 'yOff': 0 }
	var ___mousedDowned

	onNew()
		this.___windowSize = this.getWindowSize()
		this.___screenScale = this.getScreenScale()
		this.___EVITCA_drag = true

	onWindowResize(pWidth, pHeight)
		this.___windowSize.width = pWidth
		this.___windowSize.height = pHeight
		this.___screenScale = this.getScreenScale()

	onInterfaceLoaded(pInterface)
		var pProtruding
		foreach (var x in this.getInterfaceElements(pInterface))
			if (x.dragOptions.draggable && x.dragOptions.parent)
				pProtruding = x.___protruding

		foreach (var e in this.getInterfaceElements(pInterface))
			if (pProtruding)
				e.___protruding = pProtruding
				var protrudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][e.___protruding.east | (e.___protruding.west << 1) | (e.___protruding.north << 2) | (e.___protruding.south << 3)]

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
		if (this.___dragging.element)
			var realX = (this.___dragging.element.preventAutoScale ? pX * this.___screenScale.x : pX) - this.___dragging.xOff
			var realY = (this.___dragging.element.preventAutoScale ? pY * this.___screenScale.y : pY) - this.___dragging.yOff

			if (this.___dragging.element.dragOptions?.titlebar?.xPos >= 0 && this.___dragging.element.dragOptions?.titlebar?.yPos >= 0 && this.___dragging.element.dragOptions?.titlebar?.width > 0 && this.___dragging.element.dragOptions?.titlebar?.height > 0)
				var titleBarX = this.___dragging.element.xPos + this.___dragging.element.dragOptions.titlebar.xPos
				var titleBarWidthX = titleBarX + this.___dragging.element.dragOptions.titlebar.width
				var titleBarY = this.___dragging.element.yPos + this.___dragging.element.dragOptions.titlebar.yPos
				var titleBarHeightY = titleBarY + this.___dragging.element.dragOptions.titlebar.height
				var maxWidth = (this.___dragging.element.preventAutoScale ? this.___windowSize.width : World.getGameSize().width) - this.___dragging.element.width
				var maxHeight = (this.___dragging.element.preventAutoScale ? this.___windowSize.height : World.getGameSize().height) - this.___dragging.element.height
			else
				var maxWidth = (this.___dragging.element.preventAutoScale ? this.___windowSize.width : World.getGameSize().width) - this.___dragging.element.width
				var maxHeight = (this.___dragging.element.preventAutoScale ? this.___windowSize.height : World.getGameSize().height) - this.___dragging.element.height

			this.___dragging.element.setPos(Math.clamp(realX, this.___dragging.element.dragOptions.offsets.x.min, maxWidth - this.___dragging.element.dragOptions.offsets.x.max), Math.clamp(realY, this.___dragging.element.dragOptions.offsets.y.min, maxHeight - this.___dragging.element.dragOptions.offsets.y.max))

			if (this.___dragging.element.dragOptions.parent)

				realX += this.___dragging.xOff
				realY += this.___dragging.yOff

			this.___dragging.element.onMove(realX, realY)

			if (this.___dragging.element.dragOptions.beingDragged)
				return

			this.___dragging.element.dragOptions.beingDragged = true
			this.___dragging.element.onDragStart()

	onMouseDown(pDiob, pX, pY, pButton)
		if (pButton === 1)
			this.___mousedDowned = pDiob
			if (pDiob.baseType === 'Interface')
				if (pDiob.dragOptions.draggable)
					var realX = (pDiob.preventAutoScale ? pX * this.___screenScale.x : pX)
					var realY = (pDiob.preventAutoScale ? pY * this.___screenScale.y : pY)
					if (pDiob.dragOptions?.titlebar?.xPos >= 0 && pDiob.dragOptions?.titlebar?.yPos >= 0 && pDiob.dragOptions?.titlebar?.width > 0 && pDiob.dragOptions?.titlebar?.height > 0)
						var titleBarX = pDiob.xPos + pDiob.dragOptions.titlebar.xPos
						var titleBarWidthX = titleBarX + pDiob.dragOptions.titlebar.width
						var titleBarY = pDiob.yPos + pDiob.dragOptions.titlebar.yPos
						var titleBarHeightY = titleBarY + pDiob.dragOptions.titlebar.height
						if (realX >= titleBarX && realX <= titleBarWidthX && realY >= titleBarY && realY <= titleBarHeightY)
							this.___dragging = { 'element': pDiob, 'xOff': realX - titleBarX + pDiob.dragOptions.titlebar.xPos, 'yOff': realY - titleBarY + pDiob.dragOptions.titlebar.yPos }
						return

					this.___dragging = { 'element': pDiob, 'xOff': realX - pDiob.xPos, 'yOff': realY - pDiob.yPos }

	onMouseUp(pDiob, pX, pY, pButton)
		if (pButton === 1)
			if (this.___dragging.element)
				if (this.___dragging.element.dragOptions.beingDragged)
					var realX = (this.___dragging.element.preventAutoScale ? pX * this.___screenScale.x : pX)
					var realY = (this.___dragging.element.preventAutoScale ? pY * this.___screenScale.y : pY)
					this.___dragging.element.onDragEnd(realX, realY)
					return

			this.___dragging.element = null

Interface
	var parentElement
	var dragOptions = { 'draggable': false, 'beingDragged': false, 'parent': false, 'offsets': { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }, 'titlebar': { 'width': 0, 'height': 0, 'xPos': 0, 'yPos': 0 } }
	var ___defaultPos = {}
	var ___protruding = { 'east': false, 'west': false, 'north': false, 'south': false }
	var ___defaultDisplay
	anchor = 0.5

	onNew()
		var interface = this.getInterfaceName()
		this.___defaultPos = { 'x': this.xPos, 'y': this.yPos }
		this.___defaultDisplay = { 'layer': this.layer, 'plane': this.plane }
		if (this.dragOptions.titlebar)
			if (!this.dragOptions.titlebar.xPos)
				this.dragOptions.titlebar.xPos = 0

			if (!this.dragOptions.titlebar.yPos)
				this.dragOptions.titlebar.yPos = 0

		if (this.dragOptions.draggable)
			this.dragOptions.freeze = { 'x': { 'min': 0, 'max': 0, 'minWidth': 0, 'maxWidth': 0 }, 'y': { 'min': 0, 'max': 0, 'minHeight': 0, 'maxHeight': 0 }, 'updateX': false, 'updateX2': false, 'updateY': false, 'updateY2': false }
			this.dragOptions.offsets = { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }
			foreach (var e in Client.getInterfaceElements(interface))
				if (e.parentElement === this.name)
					var greaterX = (e.xPos > this.xPos + this.width) && (this.dragOptions.freeze.x.max ? e.xPos > this.dragOptions.freeze.x.max : true)
					var lesserX = (e.xPos < this.xPos) && (this.dragOptions.freeze.x.min ? e.xPos < this.dragOptions.freeze.x.min : true)
					var greaterY = (e.yPos > this.yPos + this.height) && (this.dragOptions.freeze.y.max ? e.yPos > this.dragOptions.freeze.y.max : true)
					var lesserY = (e.yPos < this.yPos) && (this.dragOptions.freeze.y.min ? e.yPos < this.dragOptions.freeze.y.min : true)

					if (greaterX)
						this.dragOptions.freeze.updateX2 = true
						this.dragOptions.freeze.x.max = e.xPos
						this.dragOptions.freeze.x.maxWidth = e.width
						this.___protruding.east = true

					else if (lesserX)
						this.dragOptions.freeze.updateX = true
						this.dragOptions.freeze.x.min = e.xPos
						this.dragOptions.freeze.x.minWidth = e.width
						this.___protruding.west = true

					if (greaterY)
						this.dragOptions.freeze.updateY2 = true
						this.dragOptions.freeze.y.max = e.yPos
						this.dragOptions.freeze.y.maxHeight = e.height
						this.___protruding.south = true

					else if (lesserY)
						this.dragOptions.freeze.updateY = true
						this.dragOptions.freeze.y.min = e.yPos
						this.dragOptions.freeze.y.minHeight = e.height
						this.___protruding.north = true

	function onDragStart()
		//...

	function onDragEnd(pX, pY)
		Client.___dragging.element.dragOptions.beingDragged = false
		Client.___dragging.element = null

	function onMove(pX, pY)
		var interface = this.getInterfaceName()
		foreach (var e in Client.getInterfaceElements(interface))
			if (e.parentElement === this.name)
				var dX = Client.getInterfaceElement(interface, e.parentElement).___defaultPos.x
				var dY = Client.getInterfaceElement(interface, e.parentElement).___defaultPos.y
				e.reposition(pX, pY, dX, dY)

	function reposition(pX, pY, dX, dY)
		var size = {
			'width': (this.preventAutoScale ? Client.___windowSize.width : World.getGameSize().width),
			'height': (this.preventAutoScale ? Client.___windowSize.height : World.getGameSize().height)
		}
		var xOff = Client.___dragging.xOff
		var yOff = Client.___dragging.yOff
		var protrudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][this.___protruding.east | (this.___protruding.west << 1) | (this.___protruding.north << 2) | (this.___protruding.south << 3)]

		if (protrudingDirection === 'none')
			this.setPos(Math.clamp(pX - xOff + this.___defaultPos.x - dX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.owner.width + this.dragOptions.offsets.x.min), Math.clamp(pY - yOff + this.___defaultPos.y - dY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.owner.height + this.dragOptions.offsets.y.min))
			return

		if (protrudingDirection === 'n' || protrudingDirection === 's' || protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ws' || protrudingDirection === 'sn' || protrudingDirection === 'wns')
			this.xPos = Math.clamp(pX - xOff + this.___defaultPos.x - dX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.owner.width + this.dragOptions.offsets.x.max)

		if (protrudingDirection === 'e' || protrudingDirection === 'ew' || protrudingDirection === 'es' || protrudingDirection === 'en' || protrudingDirection === 'ewn' || protrudingDirection === 'ews' || protrudingDirection === 'ewns' || protrudingDirection === 'ens')
			this.xPos = Math.clamp(pX - xOff + this.___defaultPos.x - dX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.offsets.x.max)

		if (protrudingDirection === 'n' || protrudingDirection === 'e' || protrudingDirection === 'w' || protrudingDirection === 'wn' || protrudingDirection === 'ew' || protrudingDirection === 'en' || protrudingDirection === 'ewn')
			this.yPos = Math.clamp(pY - yOff + this.___defaultPos.y - dY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.owner.height + this.dragOptions.offsets.y.max)

		if (protrudingDirection === 's' || protrudingDirection === 'ws' || protrudingDirection === 'sn' || protrudingDirection === 'es' || protrudingDirection === 'ews' || protrudingDirection === 'ewns' || protrudingDirection === 'ens' || protrudingDirection === 'wns')
			this.yPos = Math.clamp(pY - yOff + this.___defaultPos.y - dY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.offsets.y.max)

#END CLIENTCODE

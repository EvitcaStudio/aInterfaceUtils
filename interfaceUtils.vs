#ENABLE LOCALCLIENTCODE
#BEGIN CLIENTCODE

#DEFINE GAME_WIDTH 960
#DEFINE GAME_HEIGHT 540
// change the above to match your `World.gameWidth` and `World.gameHeight`

Client
	var ___windowSize = { 'width': GAME_WIDTH, 'height': GAME_HEIGHT }
	var ___screenScale = { 'x': 1, 'y': 1 }
	var ___dragging = { 'element': null, 'xOff': 0, 'yOff': 0 }
	var ___mousedDowned

	onNew()
		this.___windowSize = this.getWindowSize()
		this.___screenScale = this.getScreenScale()
		this.___EVITCA_drag = true

	onWindowResize(width, height)
		this.___windowSize.width = width
		this.___windowSize.height = height
		this.___screenScale = this.getScreenScale()

	function ___onInterfaceLoaded(interface, protruding)
		foreach (var e in this.getInterfaceElements(interface))
			if (protruding)
				e.___protruding = protruding
				var protudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][e.___protruding.east | (e.___protruding.west << 1) | (e.___protruding.north << 2) | (e.___protruding.south << 3)]

			if (e.dragOptions.draggable)
				if (protudingDirection === 'none')
					e.dragOptions.offsets = { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }
					continue

				if (protudingDirection === 'e' || protudingDirection === 'en' || protudingDirection === 'es' || protudingDirection === 'ens')
					e.dragOptions.offsets.x = { 'max': e.dragOptions.freeze.x.max - e.xPos - e.width + e.dragOptions.freeze.x.maxWidth, 'min': 0 }

				if (protudingDirection === 'w' || protudingDirection === 'wn' || protudingDirection === 'ws' || protudingDirection === 'wns')
					e.dragOptions.offsets.x = { 'max': 0, 'min': e.xPos - e.dragOptions.freeze.x.min }

				if (protudingDirection === 'ew' || protudingDirection === 'ewn' || protudingDirection === 'ews' || protudingDirection === 'ewns')
					e.dragOptions.offsets.x = { 'max': e.dragOptions.freeze.x.max - e.xPos - e.width + e.dragOptions.freeze.x.maxWidth, 'min': e.xPos - e.dragOptions.freeze.x.min }

				if (protudingDirection === 'n' || protudingDirection === 'en' || protudingDirection === 'wn' || protudingDirection === 'ewn')
					e.dragOptions.offsets.y = { 'max': 0, 'min': e.yPos - e.dragOptions.freeze.y.min }

				if (protudingDirection === 's' || protudingDirection === 'es' || protudingDirection === 'ws' || protudingDirection === 'ews')
					e.dragOptions.offsets.y = { 'max': e.dragOptions.freeze.y.max - e.yPos - e.height + e.dragOptions.freeze.y.maxHeight, 'min': 0 }

				if (protudingDirection === 'sn' || protudingDirection === 'ens' || protudingDirection === 'wns' || protudingDirection === 'ewns')
					e.dragOptions.offsets.y = { 'max': e.dragOptions.freeze.y.max - e.yPos - e.height + e.dragOptions.freeze.y.maxHeight, 'min': e.yPos - e.dragOptions.freeze.y.min }				
				continue

			if (e.parentElement)
				var parent = this.getInterfaceElement(interface, e.parentElement)
				var noneX = Math.sign(e.xPos - parent.xPos) === -1 ? 0 : e.xPos - parent.xPos
				var noneY = Math.sign(e.yPos - parent.yPos) === -1 ? 0 : e.yPos - parent.yPos
				e.dragOptions.owner = parent

				if (protudingDirection === 'none')
					e.dragOptions.offsets.x.max = Math.sign(e.xPos - parent.xPos) === -1 ? 0 : e.xPos - parent.xPos
					e.dragOptions.offsets.x.min = e.dragOptions.offsets.x.max
					e.dragOptions.offsets.y.max = Math.sign(e.yPos - parent.yPos) === -1 ? 0 : e.yPos - parent.yPos
					e.dragOptions.offsets.y.min = e.dragOptions.offsets.y.max
					continue	

				if (protudingDirection === 'n' || protudingDirection === 's' || protudingDirection === 'sn')
					e.dragOptions.offsets.x = { 'max': noneX, 'min': noneX }

				if (protudingDirection === 'e' || protudingDirection === 'es' || protudingDirection === 'en' || protudingDirection === 'ens')
					e.dragOptions.offsets.x = { 'max': parent.dragOptions.freeze.x.max - e.xPos + e.width, 'min': noneX }

				if (protudingDirection === 'w' || protudingDirection === 'ws' || protudingDirection === 'wns' || protudingDirection === 'wn')
					e.dragOptions.offsets.x = { 'max': e.xPos - parent.xPos, 'min': e.xPos - parent.dragOptions.freeze.x.min }

				if (protudingDirection === 'ew' || protudingDirection === 'ewn' || protudingDirection === 'ews' || protudingDirection === 'ewns')
					e.dragOptions.offsets.x = { 'max': parent.dragOptions.freeze.x.max - e.xPos + e.width, 'min': e.xPos - parent.dragOptions.freeze.x.min }

				if (protudingDirection === 'n' || protudingDirection === 'wn' || protudingDirection === 'en' || protudingDirection === 'ewn')
					e.dragOptions.offsets.y = { 'max': e.yPos - parent.yPos, 'min': e.yPos - parent.dragOptions.freeze.y.min }

				if (protudingDirection === 's' || protudingDirection === 'ws' || protudingDirection === 'es' || protudingDirection === 'ews')
					e.dragOptions.offsets.y = { 'max': parent.dragOptions.freeze.y.max - e.yPos + e.height, 'min': noneY }

				if (protudingDirection === 'e' || protudingDirection === 'w' || protudingDirection === 'ew')
					e.dragOptions.offsets.y = { 'max': noneY, 'min': noneY }

				if (protudingDirection === 'sn' || protudingDirection === 'ens' || protudingDirection === 'wns' || protudingDirection === 'ewns')
					e.dragOptions.offsets.y = { 'max': parent.dragOptions.freeze.y.max - e.yPos + e.height, 'min': e.yPos - parent.dragOptions.freeze.y.min }
	
	onMouseMove(diob, x, y)
		if (this.___dragging.element)
			var realX = (this.___dragging.element.preventAutoScale ? x * this.___screenScale.x : x) - this.___dragging.xOff
			var realY = (this.___dragging.element.preventAutoScale ? y * this.___screenScale.y : y) - this.___dragging.yOff

			if (this.___dragging.element.dragOptions?.titlebar?.xPos >= 0 && this.___dragging.element.dragOptions?.titlebar?.yPos >= 0 && this.___dragging.element.dragOptions?.titlebar?.width > 0 && this.___dragging.element.dragOptions?.titlebar?.height > 0)
				var titleBarX = this.___dragging.element.xPos + this.___dragging.element.dragOptions.titlebar.xPos
				var titleBarWidthX = titleBarX + this.___dragging.element.dragOptions.titlebar.width
				var titleBarY = this.___dragging.element.yPos + this.___dragging.element.dragOptions.titlebar.yPos
				var titleBarHeightY = titleBarY + this.___dragging.element.dragOptions.titlebar.height
				var maxWidth = (this.___dragging.element.preventAutoScale ? this.___windowSize.width: GAME_WIDTH) - this.___dragging.element.width
				var maxHeight = (this.___dragging.element.preventAutoScale ? this.___windowSize.height : GAME_HEIGHT) - this.___dragging.element.height
			else	
				var maxWidth = (this.___dragging.element.preventAutoScale ? this.___windowSize.width : GAME_WIDTH) - this.___dragging.element.width
				var maxHeight = (this.___dragging.element.preventAutoScale ? this.___windowSize.height : GAME_HEIGHT) - this.___dragging.element.height

			this.___dragging.element.setPos(Math.clamp(realX, this.___dragging.element.dragOptions.offsets.x.min, maxWidth - this.___dragging.element.dragOptions.offsets.x.max), Math.clamp(realY, this.___dragging.element.dragOptions.offsets.y.min, maxHeight - this.___dragging.element.dragOptions.offsets.y.max))

			if (this.___dragging.element.dragOptions.parent)

				realX += this.___dragging.xOff
				realY += this.___dragging.yOff
				
			this.___dragging.element.onMove(realX, realY)

			if (this.___dragging.element.dragOptions.beingDragged)
				return
				
			this.___dragging.element.dragOptions.beingDragged = true
			this.___dragging.element.onDragStart()
				
	onMouseDown(diob, x, y, button)
		if (button === 1)
			this.___mousedDowned = diob
			if (diob.baseType === 'Interface')
				if (diob.dragOptions.draggable)
					var realX = (diob.preventAutoScale ? x * this.___screenScale.x : x)
					var realY = (diob.preventAutoScale ? y * this.___screenScale.y : y)
					if (diob.dragOptions?.titlebar?.xPos >= 0 && diob.dragOptions?.titlebar?.yPos >= 0 && diob.dragOptions?.titlebar?.width > 0 && diob.dragOptions?.titlebar?.height > 0)
						var titleBarX = diob.xPos + diob.dragOptions.titlebar.xPos
						var titleBarWidthX = titleBarX + diob.dragOptions.titlebar.width
						var titleBarY = diob.yPos + diob.dragOptions.titlebar.yPos
						var titleBarHeightY = titleBarY + diob.dragOptions.titlebar.height
						if (realX >= titleBarX && realX <= titleBarWidthX && realY >= titleBarY && realY <= titleBarHeightY)
							this.___dragging = { 'element': diob, 'xOff': realX - titleBarX + diob.dragOptions.titlebar.xPos, 'yOff': realY - titleBarY + diob.dragOptions.titlebar.yPos }
						return

					this.___dragging = { 'element': diob, 'xOff': realX - diob.xPos, 'yOff': realY - diob.yPos }
				
	onMouseUp(diob, x, y, button)
		if (button === 1)
			if (this.___dragging.element)
				if (this.___dragging.element.dragOptions.beingDragged)
					var realX = (this.___dragging.element.preventAutoScale ? x * this.___screenScale.x : x)
					var realY = (this.___dragging.element.preventAutoScale ? y * this.___screenScale.y : y)
					this.___dragging.element.onDragEnd(realX, realY)
					return
				
			this.___dragging.element = null
			
Interface
	var parentElement
	var dragOptions = { 'draggable': false, 'beingDragged': false, 'parent': false, 'offsets': { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }, 'titlebar': { 'width': 0, 'height': 0, 'xPos': 0, 'yPos': 0 } }
	var ___defaultPos = {}
	var ___loaded
	var ___protruding = { 'east': false, 'west': false, 'north': false, 'south': false }
	var ___client
	var ___defaultDisplay

	onNew()
		var interface = this.getInterfaceName()
		var protruding
		this.___defaultPos = { 'x': this.xPos, 'y': this.yPos }
		this.___defaultDisplay = { 'layer': this.layer, 'plane': this.plane }
		this.___client = this.getClient()
		if (this.dragOptions.titlebar)
			if (!this.dragOptions.titlebar.xPos)
				this.dragOptions.titlebar.xPos = 0
				
			if (!this.dragOptions.titlebar.yPos)
				this.dragOptions.titlebar.yPos = 0

		if (this.dragOptions.draggable)
			this.dragOptions.freeze = { 'x': { 'min': 0, 'max': 0, 'minWidth': 0, 'maxWidth': 0 }, 'y': { 'min': 0, 'max': 0, 'minHeight': 0, 'maxHeight': 0 }, 'updateX': false, 'updateX2': false, 'updateY': false, 'updateY2': false }
			this.dragOptions.offsets = { 'x': { 'max': 0, 'min': 0 }, 'y': { 'max': 0, 'min': 0 } }
			foreach (var e in this.___client.getInterfaceElements(interface))
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

		this.___loaded = true

		foreach (var x in this.___client.getInterfaceElements(interface))
			if (!x.___loaded)
				return
			if (x.dragOptions.draggable)
				protruding = x.___protruding

		this.___client.___onInterfaceLoaded(interface, protruding) 

	function onDragStart()
		//...
				
	function onDragEnd(x, y)
		this.___client.___dragging.element.dragOptions.beingDragged = false
		this.___client.___dragging.element = null

	function onMove(x, y)
		var interface = this.getInterfaceName()
		foreach (var e in this.___client.getInterfaceElements(interface))
			if (e.parentElement === this.name)
				var dX = this.___client.getInterfaceElement(interface, e.parentElement).___defaultPos.x
				var dY = this.___client.getInterfaceElement(interface, e.parentElement).___defaultPos.y
				e.reposition(x, y, dX, dY)

	function reposition(x, y, dX, dY)
		var size = { 
			'width': (this.preventAutoScale ? this.___client.___windowSize.width : GAME_WIDTH),
			'height': (this.preventAutoScale ? this.___client.___windowSize.height : GAME_HEIGHT)
		}
		var xOff = this.___client.___dragging.xOff
		var yOff = this.___client.___dragging.yOff
		var protudingDirection = ['none', 'e', 'w', 'ew', 'n', 'en', 'wn', 'ewn', 's', 'es', 'ws', 'ews', 'sn', 'ens', 'wns', 'ewns'][this.___protruding.east | (this.___protruding.west << 1) | (this.___protruding.north << 2) | (this.___protruding.south << 3)]

		if (protudingDirection === 'none')
			this.setPos(Math.clamp(x - xOff + this.___defaultPos.x - dX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.owner.width + this.dragOptions.offsets.x.min), Math.clamp(y - yOff + this.___defaultPos.y - dY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.owner.height + this.dragOptions.offsets.y.min))
			return

		if (protudingDirection === 'n' || protudingDirection === 's' || protudingDirection === 'w' || protudingDirection === 'wn' || protudingDirection === 'ws' || protudingDirection === 'sn' || protudingDirection === 'wns')
			this.xPos = Math.clamp(x - xOff + this.___defaultPos.x - dX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.owner.width + this.dragOptions.offsets.x.max)

		if (protudingDirection === 'e' || protudingDirection === 'ew' || protudingDirection === 'es' || protudingDirection === 'en' || protudingDirection === 'ewn' || protudingDirection === 'ews' || protudingDirection === 'ewns' || protudingDirection === 'ens')
			this.xPos = Math.clamp(x - xOff + this.___defaultPos.x - dX, this.dragOptions.offsets.x.min, size.width - this.dragOptions.offsets.x.max)

		if (protudingDirection === 'n' || protudingDirection === 'e' || protudingDirection === 'w' || protudingDirection === 'wn' || protudingDirection === 'ew' || protudingDirection === 'en' || protudingDirection === 'ewn')
			this.yPos = Math.clamp(y - yOff + this.___defaultPos.y - dY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.owner.height + this.dragOptions.offsets.y.max)
		
		if (protudingDirection === 's' || protudingDirection === 'ws' || protudingDirection === 'sn' || protudingDirection === 'es' || protudingDirection === 'ews' || protudingDirection === 'ewns' || protudingDirection === 'ens' || protudingDirection === 'wns')
			this.yPos = Math.clamp(y - yOff + this.___defaultPos.y - dY, this.dragOptions.offsets.y.min, size.height - this.dragOptions.offsets.y.max)

#END CLIENTCODE
try(destroyDialog rQuickFind3DDD) catch()
try(destroyDialog rQuickSettings) catch()

global rQuickSettings
global rQuickFind3DDD
global simpleWebBrowser
global modelsList = #()


rollout rQuickSettings "Settings" (
	group "Choose Directory" (
		edittext edtFolder "" height: 20 readOnly: true
		button btnOpenFolder "Open Directory"
	)
	
	group "Models List" (
		listbox lbxModelsList "" height: 25
	)
	
	group "About" (
		label lbl0 "3DDD Quick Find Model"
		label lbl1 "MastaMan"
		label lbl2 "1.0.0"
		label lbl3 ""
		hyperLink href1 "http://3dground.net" address: "http://3dground.net" align: #center color: (color 200 200 200) hoverColor: (color 250 250 250) visitedColor: (color 200 200 200) 
	)
	
	fn uri u = dotNetObject "System.Uri" u
	
	fn findModel id = (
		find = getFilenameFile modelsList[id]
		rQuickFind3DDD.simpleWebBrowser.url = uri ("https://3ddd.ru/search?query=" + find)	
	)
	
	fn buildModelsList f = (
		list = #()
		modelsList = #()
		l1 = getFiles (f + @"\*.zip")
		l2 = getFiles (f + @"\*.rar")
		
		join list l1
		join list l2
		
		files = for l in list where matchPattern l pattern: "*.*.*" collect l
			
		lbxModelsList.items = for ff in files collect filenameFromPath ff
		
		modelsList = files
		
		if(modelsList.count > 0) do findModel 1
	)
		
	on btnOpenFolder pressed do (
		edtFolder.text = ""
		f = getSavePath caption: "Choose models directory"
		if(f == undefined or f == "") do return false
		buildModelsList f
		edtFolder.text = f
	)	
	
	on lbxModelsList doubleClicked a do (	
		try(shellLaunch modelsList[a] "") catch()
	)
	
	on lbxModelsList selected a do (
		if(a == 0) do return false
		
		findModel a	
	)
)

rollout rQuickFind3DDD "3DDD Quick Find" width:1350 height:800 (
	dotNetControl simpleWebBrowser "System.Windows.Forms.WebBrowser" pos:[0,0] width:1100 height:800
	subrollout subRollout1 "Settings"
	subrollout subRollout2 "About"
	
	
	
	on rQuickFind3DDD open do (
		
		simpleWebBrowser.ScriptErrorsSuppressed = true
		
		rQuickFind3DDD.subRollout1.pos = [1100, 0]
		rQuickFind3DDD.subRollout1.width = 250
		rQuickFind3DDD.subRollout1.height = rQuickFind3DDD.height
		
		AddSubRollout rQuickFind3DDD.subRollout1 rQuickSettings
	)		
)

createdialog rQuickFind3DDD
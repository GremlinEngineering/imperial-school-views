import AppKit
import UniformTypeIdentifiers
import UserNotifications

private final class SettingsForm: NSStackView { override var isFlipped: Bool { true } }

@MainActor final class SettingsWindow: NSWindowController, NSWindowDelegate, NSTextFieldDelegate, NSToolbarDelegate {
    let engine: Engine
    var selectedPane = 0
    let paneIDs = [NSToolbarItem.Identifier("wallpapers"), NSToolbarItem.Identifier("screensaver"), NSToolbarItem.Identifier("application")]
    var formOrder: [NSView] = [], formWidths: [ObjectIdentifier:NSLayoutConstraint] = [:], shownRows: [String] = []
    let targets = NSPopUpButton(), sources = NSPopUpButton(), collections = NSPopUpButton(), modes = NSPopUpButton()
    let conditions = NSPopUpButton(), delivery = NSPopUpButton(), formats = NSPopUpButton(), placement = NSPopUpButton(), saverMode = NSPopUpButton()
    let manage = NSButton(checkboxWithTitle:"Автоматически менять обои", target:nil, action:nil)
    let notifications = NSButton(checkboxWithTitle:"Сообщать о новых коллекциях", target:nil, action:nil)
    let saverEnabled = NSButton(checkboxWithTitle:"Подготавливать кадры для хранителя", target:nil, action:nil)
    let interval = NSTextField(string:"60"), state = NSTextField(wrappingLabelWithString:""), dirtyLabel = NSTextField(labelWithString:"")
    let hint = NSTextField(wrappingLabelWithString:""), cityLabel = NSTextField(wrappingLabelWithString:"")
    let preview = NSImageView(), previewTitle = NSTextField(labelWithString:"Сейчас на экране")
    let previewDetail = NSTextField(wrappingLabelWithString:""), previewEmpty = NSTextField(wrappingLabelWithString:"Пока нет изображения")
    let advanced = NSButton(title:"Дополнительно…", target:nil, action:nil)
    let applyButton = NSButton(title:"Применить", target:nil, action:nil), revertButton = NSButton(title:"Отменить изменения", target:nil, action:nil)
    let download = NSButton(title:"Скачать коллекцию", target:nil, action:nil), refresh = NSButton(title:"Обновить сейчас", target:nil, action:nil)
    let updateButton = NSButton(title:"Проверить обновления", target:nil, action:nil)
    private let form = SettingsForm()
    let configuration = NSView(), about = NSView(), actions = NSView()
    private let previewColumn = NSView(), statusLine = NSBox()
    private var formWidth: NSLayoutConstraint!
    private var settingsBottom: NSLayoutConstraint!, aboutBottom: NSLayoutConstraint!, previewBottomConstraint: NSLayoutConstraint!
    var rows: [String:NSView] = [:], staged: JSON = [:], drafts: [String:JSON] = [:], saverDraft: JSON = [:]
    var editingTarget = "all", wallpaperTarget = "all", advancedOpen = false, loading = false, catalogSignature = ""
    var localCatalog: JSON = [:], localTask: Task<Void,Never>?, previewTask: Task<Void,Never>?, previewURL: URL?
    private var draftPreviewSelection: [String]?, draftPreviewExpiry = Date.distantPast
    var viewer: ViewerWindow?, cityChooser: CityChooser?
    var isSaver: Bool { editingTarget == "saver" }
    var activeCatalog: JSON { staged.s("source") == "local" ? localCatalog : engine.catalog }
    var collection: JSON { activeCatalog.rows("collections").first { $0.s("id") == staged.s("collection") } ?? [:] }
    var presentation: SettingsPresentation {
        SettingsPresentation(profile:staged, collection:collection, saver:isSaver, own:saverDraft.s("mode") == "own", enabled:saverDraft.b("enabled"))
    }
    init(engine: Engine) {
        self.engine = engine
        _ = ViewsBrand.bundledFonts
        let w = NSWindow(contentRect:NSRect(x:0,y:0,width:1020,height:640), styleMask:[.titled,.closable], backing:.buffered, defer:false)
        w.contentView = ViewsBrandSurface()
        w.title = "Виды и обои · Школа Империи"; w.isReleasedWhenClosed = false; w.center()
        super.init(window:w); w.delegate = self
        saverDraft = saverOptions(engine.settings.j("saver"))
        if !engine.settings.b("linked",true), let d = engine.displays.values.first { wallpaperTarget = d.id }
        editingTarget = wallpaperTarget
        build(); selectedPane = min(2,max(0,UserDefaults.standard.integer(forKey:"settingsPane")))
        if selectedPane == 1 { editingTarget = "saver" }
        rebuildTargets(); loadTarget(); updateState()
    }
    required init?(coder:NSCoder) { nil }
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        updatePreview()
    }
    func label(_ title: String, size: CGFloat = 13, secondary: Bool = false, bold: Bool = false) -> NSTextField {
        let v = NSTextField(wrappingLabelWithString:title)
        v.font = .systemFont(ofSize:size, weight:bold ? .semibold : .regular)
        v.textColor = secondary ? ViewsBrand.muted : ViewsBrand.ink
        return v
    }
    func vertical(_ views: [NSView], spacing: CGFloat = 12) -> NSStackView {
        let s = NSStackView(); s.orientation = .vertical; s.alignment = .leading; s.spacing = spacing; s.detachesHiddenViews = false; s.setViews(views,in:.top); s.setHuggingPriority(.required,for:.vertical); return s
    }
    func fullWidth(_ view: NSView, in stack: NSStackView) {
        stack.addArrangedSubview(view)
        let width = view.widthAnchor.constraint(equalTo:stack.widthAnchor); width.isActive = true
        if stack === form { formOrder.append(view); formWidths[ObjectIdentifier(view)] = width }
    }
    func spacer() -> NSView { let v = NSView(); v.setContentHuggingPriority(.defaultLow, for:.horizontal); return v }
    func row(_ key: String, title: String = "", control: NSView) {
        let text = label(title, secondary:true); text.widthAnchor.constraint(equalToConstant:86).isActive = true
        let line = NSStackView(views:[text,control]); line.spacing = 10; line.alignment = .centerY
        control.setAccessibilityTitleUIElement(text)
        control.setContentHuggingPriority(.defaultLow,for:.horizontal)
        rows[key] = line; fullWidth(line,in:form)
    }
    func paragraph(_ key: String, _ view: NSView) { rows[key] = view; fullWidth(view,in:form) }
    func bind(_ control: NSControl, _ action: Selector) { control.target = self; control.action = action }
    func popup(_ p: NSPopUpButton, _ choices: [SettingsChoice], selected: String) {
        p.removeAllItems()
        for c in choices { p.addItem(withTitle:c.title); p.lastItem?.representedObject = c.id }
        if let i = p.itemArray.firstIndex(where: { $0.representedObject as? String == selected }) { p.selectItem(at:i) }
    }
    func value(_ p: NSPopUpButton) -> String { p.selectedItem?.representedObject as? String ?? "" }
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { paneIDs }
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { paneIDs }
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { paneIDs }
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier id: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard let index = paneIDs.firstIndex(of:id) else { return nil }
        let item = NSToolbarItem(itemIdentifier:id)
        item.label = ["Обои","Хранитель","Программа"][index]
        item.image = NSImage(systemSymbolName:["photo","moon.stars","info.circle"][index],accessibilityDescription:item.label)
        item.target = self; item.action = #selector(selectPane(_:)); return item
    }
    @objc func selectPane(_ sender: NSToolbarItem) {
        guard let next = paneIDs.firstIndex(of:sender.itemIdentifier), next != selectedPane else { return }
        selectedPane = next; tabChanged()
    }
    func build() {
        guard let content = window?.contentView else { return }
        let toolbar = NSToolbar(identifier:"ViewsPreferences"); toolbar.delegate = self
        toolbar.allowsUserCustomization = false; toolbar.autosavesConfiguration = false; toolbar.displayMode = .iconAndLabel
        window?.toolbar = toolbar; window?.toolbarStyle = .preference
        window?.setContentSize(NSSize(width:1020,height:640)); window?.center()
        func attach(_ view: NSView, to parent: NSView) { view.translatesAutoresizingMaskIntoConstraints = false; parent.addSubview(view) }
        let footer = NSView(); attach(footer,to:content)
        NSLayoutConstraint.activate([footer.leadingAnchor.constraint(equalTo:content.leadingAnchor,constant:24),footer.trailingAnchor.constraint(equalTo:content.trailingAnchor,constant:-24),footer.bottomAnchor.constraint(equalTo:content.bottomAnchor,constant:-18),footer.heightAnchor.constraint(equalToConstant:32)])
        attach(actions,to:footer); NSLayoutConstraint.activate([actions.leadingAnchor.constraint(equalTo:footer.leadingAnchor),actions.trailingAnchor.constraint(equalTo:footer.trailingAnchor),actions.topAnchor.constraint(equalTo:footer.topAnchor),actions.bottomAnchor.constraint(equalTo:footer.bottomAnchor)])
        bind(applyButton,#selector(apply)); applyButton.keyEquivalent = "\r"; bind(revertButton,#selector(revert))
        for view in [dirtyLabel,revertButton,applyButton] { attach(view,to:actions) }
        dirtyLabel.font = .systemFont(ofSize:11); dirtyLabel.textColor = ViewsBrand.muted
        NSLayoutConstraint.activate([applyButton.trailingAnchor.constraint(equalTo:actions.trailingAnchor),applyButton.centerYAnchor.constraint(equalTo:actions.centerYAnchor),applyButton.widthAnchor.constraint(equalToConstant:156),revertButton.trailingAnchor.constraint(equalTo:applyButton.leadingAnchor,constant:-10),revertButton.centerYAnchor.constraint(equalTo:actions.centerYAnchor),dirtyLabel.leadingAnchor.constraint(equalTo:actions.leadingAnchor),dirtyLabel.centerYAnchor.constraint(equalTo:actions.centerYAnchor),dirtyLabel.trailingAnchor.constraint(lessThanOrEqualTo:revertButton.leadingAnchor,constant:-12)])
        attach(state,to:content); state.font = .systemFont(ofSize:12); state.textColor = ViewsBrand.muted; state.maximumNumberOfLines = 2; state.isSelectable = true
        NSLayoutConstraint.activate([state.leadingAnchor.constraint(equalTo:footer.leadingAnchor),state.trailingAnchor.constraint(equalTo:footer.trailingAnchor),state.bottomAnchor.constraint(equalTo:footer.topAnchor,constant:-12),state.heightAnchor.constraint(equalToConstant:32)])
        statusLine.boxType = .separator; attach(statusLine,to:content)
        NSLayoutConstraint.activate([statusLine.leadingAnchor.constraint(equalTo:footer.leadingAnchor),statusLine.trailingAnchor.constraint(equalTo:footer.trailingAnchor),statusLine.bottomAnchor.constraint(equalTo:state.topAnchor,constant:-12)])
        let body = NSView(); attach(body,to:content)
        settingsBottom = body.bottomAnchor.constraint(equalTo:statusLine.topAnchor,constant:-18)
        aboutBottom = body.bottomAnchor.constraint(equalTo:content.bottomAnchor,constant:-24)
        NSLayoutConstraint.activate([body.leadingAnchor.constraint(equalTo:footer.leadingAnchor),body.trailingAnchor.constraint(equalTo:footer.trailingAnchor),body.topAnchor.constraint(equalTo:content.topAnchor,constant:20),settingsBottom])
        attach(configuration,to:body); attach(about,to:body)
        for view in [configuration,about] { NSLayoutConstraint.activate([view.leadingAnchor.constraint(equalTo:body.leadingAnchor),view.trailingAnchor.constraint(equalTo:body.trailingAnchor),view.topAnchor.constraint(equalTo:body.topAnchor),view.bottomAnchor.constraint(equalTo:body.bottomAnchor)]) }

        let scroll = NSScrollView(); attach(scroll,to:configuration); scroll.hasVerticalScroller = true; scroll.autohidesScrollers = true; scroll.drawsBackground = false; scroll.borderType = .noBorder
        formWidth = scroll.widthAnchor.constraint(equalToConstant:368)
        NSLayoutConstraint.activate([scroll.leadingAnchor.constraint(equalTo:configuration.leadingAnchor),scroll.topAnchor.constraint(equalTo:configuration.topAnchor),scroll.bottomAnchor.constraint(equalTo:configuration.bottomAnchor),formWidth])
        form.orientation = .vertical; form.alignment = .leading; form.spacing = 12; form.detachesHiddenViews = false
        form.setHuggingPriority(.required,for:.vertical); form.translatesAutoresizingMaskIntoConstraints = false; scroll.documentView = form
        NSLayoutConstraint.activate([form.leadingAnchor.constraint(equalTo:scroll.contentView.leadingAnchor),form.trailingAnchor.constraint(equalTo:scroll.contentView.trailingAnchor,constant:-8),form.topAnchor.constraint(equalTo:scroll.contentView.topAnchor)])
        let targetLabel = label("Экран",size:11,secondary:true)
        targets.setAccessibilityTitleUIElement(targetLabel)
        let targetBox = vertical([targetLabel,targets],spacing:6)
        targets.widthAnchor.constraint(equalTo:targetBox.widthAnchor).isActive = true; paragraph("target",targetBox)
        paragraph("saverEnabled",saverEnabled); row("saverMode",title:"Кадры",control:saverMode)
        paragraph("saverOff",label("Установите хранитель и выберите его в настройках заставки macOS.",size:13,secondary:true))
        let sectionTitle = label("Коллекция и условия"); sectionTitle.font = ViewsBrand.heading(18); sectionTitle.textColor = ViewsBrand.accent
        paragraph("profileTitle",sectionTitle)
        row("source",title:"Источник",control:sources); row("collection",title:"Коллекция",control:collections)
        row("conditions",title:"Условия",control:conditions); row("mode",title:"Смена",control:modes)
        hint.font = .systemFont(ofSize:12); hint.textColor = ViewsBrand.muted; paragraph("hint",hint)
        cityLabel.font = .systemFont(ofSize:12); cityLabel.textColor = ViewsBrand.ink; cityLabel.isSelectable = true
        let cityBox = vertical([cityLabel,NSButton(title:"Выбрать город…",target:self,action:#selector(chooseCity))],spacing:8)
        row("city",title:"Мой город",control:cityBox)
        let attribution = NSButton(title:"Open-Meteo · GeoNames · CC BY 4.0",target:self,action:#selector(openAttribution)); attribution.bezelStyle = .inline; paragraph("attribution",attribution)
        row("placement",title:"На экране",control:placement); paragraph("manage",manage)
        interval.widthAnchor.constraint(equalToConstant:76).isActive = true; interval.delegate = self; interval.setAccessibilityLabel("Интервал в секундах")
        let intervalRow = NSStackView(views:[interval,label("с (10–3600)",size:12,secondary:true),spacer()]); intervalRow.spacing = 8
        row("interval",title:"Интервал",control:intervalRow)
        bind(advanced,#selector(toggleAdvanced)); advanced.title = ""; advanced.setButtonType(.pushOnPushOff); advanced.bezelStyle = .disclosure; advanced.setAccessibilityLabel("Дополнительные настройки")
        let disclosure = NSView(); attach(advanced,to:disclosure); let disclosureLabel = label("Дополнительно",size:12); attach(disclosureLabel,to:disclosure)
        NSLayoutConstraint.activate([disclosure.heightAnchor.constraint(equalToConstant:22),advanced.leadingAnchor.constraint(equalTo:disclosure.leadingAnchor),advanced.centerYAnchor.constraint(equalTo:disclosure.centerYAnchor),advanced.widthAnchor.constraint(equalToConstant:16),advanced.heightAnchor.constraint(equalToConstant:16),disclosureLabel.leadingAnchor.constraint(equalTo:advanced.trailingAnchor,constant:6),disclosureLabel.centerYAnchor.constraint(equalTo:advanced.centerYAnchor)])
        paragraph("advanced",disclosure)
        row("format",title:"Размер",control:formats); row("delivery",title:"Загрузка",control:delivery); paragraph("notifications",notifications)
        paragraph("import",NSButton(title:"Импортировать ZIP…",target:self,action:#selector(importZIP)))
        paragraph("saverInstall",NSButton(title:"Установить хранитель…",target:self,action:#selector(installSaver)))

        let right = previewColumn; attach(right,to:configuration)
        NSLayoutConstraint.activate([right.leadingAnchor.constraint(equalTo:scroll.trailingAnchor,constant:24),right.trailingAnchor.constraint(equalTo:configuration.trailingAnchor),right.topAnchor.constraint(equalTo:configuration.topAnchor),right.bottomAnchor.constraint(equalTo:configuration.bottomAnchor)])
        previewTitle.font = ViewsBrand.heading(20); previewTitle.textColor = ViewsBrand.accent; attach(previewTitle,to:right)
        refresh.title = "Обновить обои"; bind(refresh,#selector(refreshNow)); attach(refresh,to:right)
        NSLayoutConstraint.activate([previewTitle.leadingAnchor.constraint(equalTo:right.leadingAnchor),previewTitle.topAnchor.constraint(equalTo:right.topAnchor,constant:2),refresh.trailingAnchor.constraint(equalTo:right.trailingAnchor),refresh.centerYAnchor.constraint(equalTo:previewTitle.centerYAnchor),previewTitle.trailingAnchor.constraint(lessThanOrEqualTo:refresh.leadingAnchor,constant:-12)])
        let picture = NSBox(); picture.boxType = .custom; picture.borderWidth = 1; picture.borderColor = .separatorColor; picture.cornerRadius = 8; picture.fillColor = .black; picture.contentViewMargins = .zero
        preview.imageScaling = .scaleProportionallyUpOrDown; picture.contentView = preview; attach(picture,to:right)
        let pictureHeight = picture.heightAnchor.constraint(equalToConstant:290); pictureHeight.priority = .defaultHigh
        NSLayoutConstraint.activate([picture.leadingAnchor.constraint(equalTo:right.leadingAnchor),picture.trailingAnchor.constraint(equalTo:right.trailingAnchor),picture.topAnchor.constraint(equalTo:right.topAnchor,constant:36),pictureHeight,picture.heightAnchor.constraint(greaterThanOrEqualToConstant:90)])
        attach(previewEmpty,to:preview); previewEmpty.alignment = .center; previewEmpty.textColor = .white; previewEmpty.font = .systemFont(ofSize:13)
        NSLayoutConstraint.activate([previewEmpty.centerXAnchor.constraint(equalTo:preview.centerXAnchor),previewEmpty.centerYAnchor.constraint(equalTo:preview.centerYAnchor),previewEmpty.widthAnchor.constraint(lessThanOrEqualTo:preview.widthAnchor,constant:-32)])
        previewDetail.font = ViewsBrand.details(12); previewDetail.textColor = ViewsBrand.ink; previewDetail.maximumNumberOfLines = 2; previewDetail.isSelectable = true; attach(previewDetail,to:right)
        NSLayoutConstraint.activate([previewDetail.leadingAnchor.constraint(equalTo:right.leadingAnchor),previewDetail.trailingAnchor.constraint(equalTo:right.trailingAnchor),previewDetail.topAnchor.constraint(equalTo:picture.bottomAnchor,constant:10),previewDetail.heightAnchor.constraint(equalToConstant:34)])
        let viewerButton = NSButton(title:"Открыть просмотрщик…",target:self,action:#selector(openViewer)); bind(download,#selector(downloadCollection)); attach(viewerButton,to:right); attach(download,to:right)
        NSLayoutConstraint.activate([viewerButton.leadingAnchor.constraint(equalTo:right.leadingAnchor),viewerButton.topAnchor.constraint(equalTo:previewDetail.bottomAnchor,constant:10),download.leadingAnchor.constraint(equalTo:viewerButton.trailingAnchor,constant:8),download.centerYAnchor.constraint(equalTo:viewerButton.centerYAnchor)])
        previewBottomConstraint = viewerButton.bottomAnchor.constraint(lessThanOrEqualTo:right.bottomAnchor)
        bind(updateButton,#selector(checkUpdate))
        let appTitle = label("Виды и обои"); appTitle.font = ViewsBrand.heading(27); appTitle.textColor = ViewsBrand.accent
        let intro = label("Игровые пейзажи на рабочем столе и в хранителе экрана."); intro.font = ViewsBrand.intro(15)
        let details = vertical([appTitle,label("Школа Империи · версия \(DataModel.version)",secondary:true),intro,updateButton,NSButton(title:"Исходники на GitHub",target:self,action:#selector(openRepository)),NSButton(title:"Сайт коллекций",target:self,action:#selector(openSite)),NSButton(title:"Лицензии компонентов…",target:self,action:#selector(openLicenses))],spacing:15)
        attach(details,to:about); NSLayoutConstraint.activate([details.leadingAnchor.constraint(equalTo:about.leadingAnchor,constant:16),details.trailingAnchor.constraint(equalTo:about.trailingAnchor,constant:-16),details.topAnchor.constraint(equalTo:about.topAnchor,constant:16)])
        popup(sources,[SettingsChoice("day","Обои дня"),SettingsChoice("online","Коллекция с сайта"),SettingsChoice("weather","Погода и динамические темы"),SettingsChoice("local","Скачанная коллекция")],selected:"")
        popup(placement,[SettingsChoice("fill","Заполнить экран"),SettingsChoice("fit","Вписать целиком")],selected:"")
        popup(delivery,[SettingsChoice("images","Только нужные кадры"),SettingsChoice("zip","Вся погодная коллекция")],selected:"")
        popup(saverMode,[SettingsChoice("inherit","Как на рабочем столе"),SettingsChoice("own","Своя коллекция")],selected:"")
        bind(targets,#selector(targetChanged)); bind(sources,#selector(sourceChanged)); bind(collections,#selector(collectionChanged)); bind(conditions,#selector(conditionChanged))
        for p in [modes,delivery,formats,placement] { bind(p,#selector(controlChanged)) }
        for b in [manage,notifications] { bind(b,#selector(controlChanged)) }
        bind(saverMode,#selector(saverChanged)); bind(saverEnabled,#selector(saverChanged))
    }
    func select(_ p: NSPopUpButton, _ id: String) { if let i = p.itemArray.firstIndex(where: { $0.representedObject as? String == id }) { p.selectItem(at:i) } }
    func rebuildTargets() {
        var choices = [SettingsChoice("all","Все экраны вместе")] + engine.displays.values.map { SettingsChoice($0.id,"\($0.title) · \(Int($0.width))×\(Int($0.height))") }
        if !choices.contains(where: { $0.id == wallpaperTarget }) { choices.append(SettingsChoice(wallpaperTarget,"Экран сейчас отключён")) }
        popup(targets,choices,selected:wallpaperTarget)
        targets.toolTip = targets.titleOfSelectedItem
    }
    func savedProfile() -> JSON {
        DataModel.profile(isSaver ? engine.settings.j("saver").j("profile") : editingTarget == "all" ? engine.settings.j("common") : DataModel.profile(for:editingTarget,settings:engine.settings))
    }
    func saverOptions(_ input: JSON) -> JSON { ["enabled":input.b("enabled"),"mode":input.s("mode","inherit"),"interval":input.n("interval",60)] }
    private func resizeForPane(about: Bool, saverOff: Bool) {
        guard let window else { return }
        let target = about ? NSSize(width:520,height:350) : saverOff ? NSSize(width:520,height:280) : NSSize(width:1020,height:600)
        let area = (window.screen ?? NSScreen.main)?.visibleFrame ?? .infinite
        let chrome = window.frame.height - (window.contentView?.bounds.height ?? target.height)
        let size = NSSize(width:min(target.width,area.width - 16),height:min(target.height,area.height - chrome - 16))
        formWidth.constant = min(368, saverOff || about ? size.width - 96 : size.width * 0.42)
        guard window.contentView?.bounds.size != size else { return }
        var frame = window.frameRect(forContentRect:NSRect(origin:.zero,size:size))
        frame.origin.x = max(area.minX,min(window.frame.midX - frame.width / 2,area.maxX - frame.width))
        frame.origin.y = max(area.minY,min(window.frame.maxY - frame.height,area.maxY - frame.height))
        window.setFrame(frame,display:window.isVisible)
    }
    func remember() { capture(); drafts[editingTarget] = staged }
    func loadTarget() { staged = drafts[editingTarget] ?? savedProfile(); render() }
    func render() {
        loading = true; defer { loading = false }
        select(sources,staged.s("source")); select(placement,staged.s("placement")); select(delivery,staged.s("weather_delivery"))
        manage.state = staged.b("manage",true) ? .on : .off; notifications.state = staged.b("notify_collections",true) ? .on : .off
        saverEnabled.state = saverDraft.b("enabled") ? .on : .off; select(saverMode,saverDraft.s("mode")); interval.stringValue = String(Int(saverDraft.n("interval",60)))
        let weather = staged.s("source") == "weather", id = staged.s("collection")
        let candidates = activeCatalog.rows("collections").filter { weather ? ["weather","dynamic"].contains($0.s("type")) : !["weather","dynamic"].contains($0.s("type")) }
        var entries = candidates.map { SettingsChoice($0.s("id"),$0.s("title")) }
        if weather { entries.insert(SettingsChoice("__weather_day__","Погода дня — выбор сервера"),at:0) }
        if !id.isEmpty && !entries.contains(where: { $0.id == id }) { entries.append(SettingsChoice(id,"\(id) · недоступна")) }
        popup(collections,entries,selected:id); collections.isEnabled = !entries.isEmpty
        collections.toolTip = collections.titleOfSelectedItem
        if staged.s("source") != "day", id.isEmpty, let first = entries.first { staged["collection"] = first.id }
        let modeChoices = SettingsPresentation.modes(source:staged.s("source"),collection:collection,saver:isSaver)
        popup(modes,modeChoices,selected:staged.s("mode")); staged["mode"] = value(modes)
        let choice = presentation.condition
        popup(conditions,presentation.conditions,selected:choice)
        if !presentation.conditions.isEmpty { staged = SettingsPresentation.settingCondition(value(conditions),in:staged) }
        if presentation.dynamic { staged["weather_provider"] = "server"; staged["weather_source"] = "real"; staged["weather_delivery"] = "images" }
        if presentation.dailyWeather { staged["weather_provider"] = "server"; staged["weather_delivery"] = "images" }
        select(delivery,staged.s("weather_delivery"))
        var sizes = [SettingsChoice("auto","По размеру экрана")]
        if weather {
            sizes += collection.j("formats").keys.sorted().compactMap { key in let f = collection.j("formats").j(key); return f.n("width") > f.n("height") ? SettingsChoice(key,"\(Int(f.n("width")))×\(Int(f.n("height"))) · \(key)") : nil }
        } else {
            let values = Set(activeCatalog.rows("items").filter { staged.s("source") == "day" || $0.s("collection") == staged.s("collection") }.flatMap { $0.rows("files").filter { $0.n("width") > $0.n("height") }.map { "\(Int($0.n("width")))x\(Int($0.n("height")))" } })
            sizes += values.sorted().map { SettingsChoice($0,$0.replacingOccurrences(of:"x",with:"×")) }
        }
        let sizeKey = weather ? "weather_format" : "format"
        // Preserve an unavailable explicit format rather than silently changing it.
        let size = staged.s(sizeKey,"auto")
        if !sizes.contains(where: { $0.id == size }) { sizes.append(SettingsChoice(size,"\(size) · недоступен")) }
        popup(formats,sizes,selected:size)
        let p = presentation, profile = p.showProfile
        hint.stringValue = p.hint
        if p.showCollection && entries.isEmpty { hint.stringValue = staged.s("source") == "local" ? "Импортируйте ZIP или скачайте коллекцию с сайта." : "Каталог загружается…" }
        let visible: [String:Bool] = ["target":!isSaver,"saverEnabled":isSaver,"saverMode":isSaver && p.enabled,"saverOff":isSaver && !p.enabled,"profileTitle":profile,"source":profile,"collection":p.showCollection,"conditions":profile && !p.conditions.isEmpty,"mode":profile && modeChoices.count > 1,"hint":profile && !hint.stringValue.isEmpty,"city":p.showCity,"attribution":p.showCity,"placement":profile,"manage":profile && !isSaver,"interval":p.showInterval,"advanced":profile,"format":profile && advancedOpen,"delivery":p.showDelivery && advancedOpen,"notifications":profile && advancedOpen,"import":profile && staged.s("source") == "local","saverInstall":isSaver]
        let next = formOrder.compactMap { view in rows.first(where: { $0.value === view })?.key }.filter { visible[$0] ?? false }
        if next != shownRows {
            NSLayoutConstraint.deactivate(Array(formWidths.values))
            for view in form.arrangedSubviews { form.removeArrangedSubview(view); view.removeFromSuperview() }
            let views = next.compactMap { rows[$0] }; form.setViews(views,in:.top)
            for view in views { formWidths[ObjectIdentifier(view)]?.isActive = true }
            shownRows = next
        }
        let c = staged.j("weather_city")
        cityLabel.stringValue = c.isEmpty ? "Город ещё не выбран" : [c.s("name"),c.s("admin1"),c.s("country")].filter { !$0.isEmpty }.joined(separator:", ")
        advanced.state = advancedOpen ? .on : .off
        download.isHidden = !p.showDownload; refresh.isHidden = isSaver
        let isAbout = selectedPane == 2, saverOff = isSaver && !p.enabled
        configuration.isHidden = isAbout; about.isHidden = !isAbout; actions.isHidden = isAbout
        statusLine.isHidden = isAbout; state.isHidden = isAbout
        if isAbout { settingsBottom.isActive = false; aboutBottom.isActive = true }
        else { aboutBottom.isActive = false; settingsBottom.isActive = true }
        previewColumn.isHidden = saverOff
        if isAbout || saverOff { previewBottomConstraint.isActive = false }
        resizeForPane(about:isAbout,saverOff:saverOff)
        if !isAbout && !saverOff { previewBottomConstraint.isActive = true }
        window?.title = isAbout ? "Программа · Виды и обои" : isSaver ? "Хранитель · Виды и обои" : "Обои · Виды и обои"
        window?.toolbar?.selectedItemIdentifier = paneIDs[selectedPane]
        applyButton.title = isSaver ? "Сохранить настройки" : "Применить"
        updateDirty(); updatePreview()
    }
    func capture() {
        staged["source"] = value(sources); staged["online"] = value(sources) != "local"
        if value(sources) != "day" { staged["collection"] = value(collections) }
        staged["mode"] = value(modes)
        if !presentation.conditions.isEmpty { staged = SettingsPresentation.settingCondition(value(conditions),in:staged) }
        staged["weather_delivery"] = presentation.showCity ? "zip" : value(delivery)
        staged[staged.s("source") == "weather" ? "weather_format" : "format"] = value(formats)
        staged["placement"] = value(placement); staged["manage"] = manage.state == .on; staged["notify_collections"] = notifications.state == .on
        if isSaver {
            saverDraft["enabled"] = saverEnabled.state == .on; saverDraft["mode"] = value(saverMode)
            if let number = Double(interval.stringValue), number.isFinite { saverDraft["interval"] = min(3600,max(10,number)) }
        }
    }
    func updateDirty() {
        let dirty = !SettingsPresentation.equal(staged,savedProfile()) || (isSaver && !SettingsPresentation.equal(saverDraft,saverOptions(engine.settings.j("saver")))) || (!isSaver && editingTarget == "all" && !engine.settings.b("linked",true))
        applyButton.isEnabled = dirty; revertButton.isEnabled = dirty; dirtyLabel.stringValue = dirty ? "Есть несохранённые изменения" : ""
    }
    func updateState() {
        state.stringValue = engine.status + (engine.progress.isEmpty ? "" : "\n" + engine.progress)
        updateButton.title = engine.update.map { "Скачать версию \($0.s("version"))…" } ?? "Проверить обновления"
        rebuildTargets()
        let signature = DataModel.sha((try? JSONSerialization.data(withJSONObject:engine.catalog,options:[.sortedKeys])) ?? Data())
        if signature != catalogSignature { catalogSignature = signature; render() } else { updateDirty(); updatePreview() }
        localTask?.cancel(); localTask = Task { [weak self] in
            guard let self else { return }; let packs = await engine.store.localPacks(); guard !Task.isCancelled else { return }
            let catalog = DataModel.merging(packs:packs,catalog:[:])
            guard !SettingsPresentation.equal(catalog,localCatalog) else { return }; localCatalog = catalog
            if staged.s("source") == "local" { render() }
        }
    }
    func showPreview(_ url: URL?, title: String, detail: String, empty: String) {
        previewTitle.stringValue = title; previewDetail.stringValue = detail; previewEmpty.stringValue = empty
        if previewURL != url { previewURL = url; preview.image = url.flatMap { NSImage(contentsOf:$0) } }
        previewEmpty.isHidden = preview.image != nil
    }
    private func clearPreviewRequest() {
        previewTask?.cancel(); previewTask = nil; draftPreviewSelection = nil
    }
    private func showDraftPreview(for display: Display, selection: [String]) {
        let request = selection + [editingTarget,display.id,String(display.width),String(display.height)]
        if draftPreviewSelection == request && Date() < draftPreviewExpiry { return }
        clearPreviewRequest()
        draftPreviewSelection = request; draftPreviewExpiry = .distantFuture
        let profile = staged
        let name = collection.s("title", collections.titleOfSelectedItem ?? "")
        showPreview(nil,title:"Предпросмотр",detail:name,empty:"Загружаю кадр…")
        if (presentation.showCollection && profile.s("collection").isEmpty) || (presentation.showCity && (try? City(profile.j("weather_city"))) == nil) {
            showPreview(nil,title:"Предпросмотр",detail:name,empty:presentation.showCity ? "Выберите город" : "Выберите коллекцию")
            return
        }
        previewTask = Task { [weak self] in
            guard let self else { return }
            do {
                let frame = try await engine.resolve(profile, display:display, force:false, preview:true)
                try Task.checkCancellation()
                draftPreviewExpiry = frame.until ?? Date().addingTimeInterval(60)
                showPreview(frame.url,title:"Предпросмотр",detail:name.isEmpty ? frame.rule.s("title") : name,empty:"Кадр недоступен")
            } catch is CancellationError {
                if !Task.isCancelled { draftPreviewSelection = nil }
            } catch {
                guard !Task.isCancelled else { return }
                draftPreviewExpiry = Date().addingTimeInterval(5)
                showPreview(nil,title:"Предпросмотр",detail:name,empty:error.localizedDescription)
            }
        }
    }
    func updatePreview() {
        guard window?.isVisible == true, selectedPane != 2, !isSaver || saverDraft.b("enabled") else { clearPreviewRequest(); return }
        let d = engine.displays.values.first { $0.id == wallpaperTarget } ?? engine.displays.values.first
        guard let d else { clearPreviewRequest(); showPreview(nil,title:"Просмотр",detail:"",empty:"Ожидаю экран…"); return }
        let selection = SettingsPresentation.frameSelection(staged)
        let own = isSaver && saverDraft.s("mode") == "own"
        let savedSaver = engine.settings.j("saver")
        if (!isSaver || own) && (selection != SettingsPresentation.frameSelection(savedProfile()) || (own && (!savedSaver.b("enabled") || savedSaver.s("mode") != "own"))) {
            showDraftPreview(for:d,selection:selection); return
        }
        clearPreviewRequest()
        if own {
            if previewTitle.stringValue != "Кадр хранителя" { showPreview(nil,title:"Кадр хранителя",detail:"",empty:"Ожидаю кадр…") }
            previewTask = Task { [weak self] in
                guard let self else { return }; let saved = await engine.store.json("saver-state.json") ?? [:]
                let file = saved.s("configuration_revision") == engine.settings.s("configuration_revision") ? saved.j("targets").j(d.id).j("fallback") : [:]
                let url = await engine.store.cached(file); guard !Task.isCancelled else { return }
                showPreview(url,title:"Кадр хранителя",detail:url == nil ? "" : d.title,empty:"Ожидаю кадр…")
            }; return
        }
        let url = d.screen.flatMap { NSWorkspace.shared.desktopImageURL(for:$0) }
        let frame = engine.current[d.id], currentCollection = frame?.rule.s("collection") ?? ""
        let title = engine.catalog.rows("collections").first { $0.s("id") == currentCollection }?.s("title") ?? ""
        let info = [title,"\(d.title) · \(Int(d.width))×\(Int(d.height))"].filter { !$0.isEmpty }.joined(separator:"\n")
        showPreview(url,title:isSaver ? "Как на рабочем столе" : "Сейчас на экране",detail:info,empty:"Текущие обои недоступны для просмотра")
    }
    @objc func tabChanged() {
        remember()
        UserDefaults.standard.set(selectedPane,forKey:"settingsPane")
        if selectedPane != 2 { editingTarget = selectedPane == 1 ? "saver" : wallpaperTarget; loadTarget() } else { render() }
    }
    @objc func targetChanged() { remember(); wallpaperTarget = value(targets); editingTarget = wallpaperTarget; loadTarget() }
    @objc func sourceChanged() {
        let source = value(sources); capture(); staged["source"] = source; staged["collection"] = ""
        staged["mode"] = source == "weather" ? "weather" : source == "day" ? "featured" : "daily"
        staged["format"] = "auto"; staged["weather_format"] = "auto"; render()
    }
    @objc func collectionChanged() { capture(); staged["weather_format"] = "auto"; staged["format"] = "auto"; render() }
    @objc func conditionChanged() { capture(); render() }
    @objc func controlChanged() { if !loading { capture(); render() } }
    @objc func saverChanged() { capture(); render() }
    @objc func toggleAdvanced() { capture(); advancedOpen.toggle(); render() }
    func controlTextDidChange(_ obj: Notification) { if !loading { capture(); updateDirty() } }
    @objc func revert() { window?.makeFirstResponder(nil); drafts.removeValue(forKey:editingTarget); if isSaver { saverDraft = saverOptions(engine.settings.j("saver")) }; loadTarget() }
    @objc func apply() {
        window?.makeFirstResponder(nil); capture()
        if presentation.showCity && (try? City(staged.j("weather_city"))) == nil { state.stringValue = "Выберите город для местной погоды"; chooseCity(); return }
        if presentation.showCollection && staged.s("collection").isEmpty { state.stringValue = "Сначала выберите коллекцию"; return }
        if isSaver {
            var saver = engine.settings.j("saver"); for (key,value) in saverDraft { saver[key] = value }; engine.settings["saver"] = saver
        }
        engine.save(profile:staged,target:editingTarget); drafts.removeValue(forKey:editingTarget); staged = savedProfile()
        if presentation.showProfile && notifications.state == .on { UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound]) { _,_ in } }
        render()
    }
    @objc func chooseCity() {
        guard let window, cityChooser == nil else { return }
        let target = editingTarget
        let chooser = CityChooser { [weak self] city in
            guard let self else { return }; cityChooser = nil
            guard let city, target == editingTarget else { return }; staged["weather_city"] = city; render()
        }
        cityChooser = chooser; window.beginSheet(chooser.window!)
    }
    @objc func refreshNow() { engine.refresh(force:true) }
    @objc func openViewer() { if viewer == nil { viewer = ViewerWindow(engine:engine) }; viewer?.showWindow(nil); viewer?.reload(); NSApp.activate(ignoringOtherApps:true) }
    @objc func downloadCollection() { capture(); engine.downloadCollection(staged,target:editingTarget) }
    @objc func importZIP() {
        guard let window else { return }; let panel = NSOpenPanel(); panel.allowedContentTypes = [.zip]; panel.canChooseDirectories = false; panel.allowsMultipleSelection = false
        panel.beginSheetModal(for:window) { [weak self] response in if response == .OK, let url = panel.url { self?.engine.importZIP(url) } }
    }
    @objc func checkUpdate() {
        if let release = engine.update, let url = URL(string:release.s("url")) { NSWorkspace.shared.open(url); return }
        Task { await engine.checkUpdate(manual:true) }
    }
    @objc func installSaver() {
        if let url = Bundle.main.builtInPlugInsURL?.appendingPathComponent("Imperial School Views.saver"), FileManager.default.fileExists(atPath:url.path) { NSWorkspace.shared.open(url) }
        else { state.stringValue = "Хранитель отсутствует в этой сборке" }
    }
    @objc func openAttribution() { NSWorkspace.shared.open(URL(string:"https://open-meteo.com/")!) }
    @objc func openRepository() { NSWorkspace.shared.open(URL(string:"https://github.com/GremlinEngineering/imperial-school-views")!) }
    @objc func openSite() { NSWorkspace.shared.open(URL(string:"https://games.oopssre.ru/")!) }
    @objc func openLicenses() { if let url = Bundle.main.resourceURL?.appendingPathComponent("licences") { NSWorkspace.shared.open(url) } }
    func windowWillClose(_ notification: Notification) { cityChooser?.cancel(); clearPreviewRequest(); remember() }
}

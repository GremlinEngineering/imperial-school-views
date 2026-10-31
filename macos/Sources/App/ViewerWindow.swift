import AppKit
import ImageIO

@MainActor final class ViewerWindow: NSWindowController, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {
    let engine: Engine, table = NSTableView(), scroll = NSScrollView(), image = NSImageView(), details = NSTextField(wrappingLabelWithString:""), slideshow = NSButton(title:"▶ Слайд-шоу",target:nil,action:nil), speed = NSPopUpButton()
    var programmaticSelection = false
    var all: [GalleryRow] = [], rows: [GalleryRow] = [], filters: [String: NSPopUpButton] = [:], timer: Timer?, generation = 0, shown: URL?
    init(engine: Engine) {
        self.engine = engine; let w = NSWindow(contentRect:NSRect(x:0,y:0,width:1200,height:800),styleMask:[.titled,.closable,.miniaturizable,.resizable],backing:.buffered,defer:false)
        w.title = "Просмотрщик коллекций"; w.minSize = NSSize(width:1050,height:600); w.center(); super.init(window:w); w.delegate = self; build()
    }
    required init?(coder:NSCoder) { return nil }
    func build() {
        guard let content = window?.contentView else { return }; let outer = NSStackView(); outer.orientation = .vertical; outer.spacing = 10; outer.translatesAutoresizingMaskIntoConstraints = false; content.addSubview(outer)
        NSLayoutConstraint.activate([outer.leadingAnchor.constraint(equalTo:content.leadingAnchor,constant:14),outer.trailingAnchor.constraint(equalTo:content.trailingAnchor,constant:-14),outer.topAnchor.constraint(equalTo:content.topAnchor,constant:14),outer.bottomAnchor.constraint(equalTo:content.bottomAnchor,constant:-14)])
        let top = NSStackView(); top.spacing = 6
        for (key,title) in [("collection","Коллекции"),("rendition","Форматы"),("season","Сезоны"),("time_of_day","Время суток"),("weather","Погода"),("moon_phase","Луна")] { let p = NSPopUpButton(); p.widthAnchor.constraint(equalToConstant:155).isActive = true; p.font = .systemFont(ofSize:11); p.addItem(withTitle:title); p.lastItem?.representedObject = ""; p.target = self; p.action = #selector(filterChanged); filters[key] = p; top.addArrangedSubview(p) }; outer.addArrangedSubview(top)
        let split = NSSplitView(); split.isVertical = true; split.dividerStyle = .thin; outer.addArrangedSubview(split); split.widthAnchor.constraint(equalTo:outer.widthAnchor).isActive = true
        let list = NSScrollView(); list.hasVerticalScroller = true; list.documentView = table; table.addTableColumn(NSTableColumn(identifier:NSUserInterfaceItemIdentifier("image"))); table.headerView = nil; table.rowHeight = 76; table.delegate = self; table.dataSource = self; table.allowsEmptySelection = false; table.target = self; table.action = #selector(selectRow); split.addArrangedSubview(list)
        list.widthAnchor.constraint(greaterThanOrEqualToConstant:230).isActive = true; list.widthAnchor.constraint(lessThanOrEqualToConstant:340).isActive = true
        scroll.hasHorizontalScroller = true; scroll.hasVerticalScroller = true; scroll.allowsMagnification = true; scroll.minMagnification = 0.01; scroll.maxMagnification = 16; scroll.backgroundColor = .black; scroll.documentView = image; image.imageScaling = .scaleProportionallyUpOrDown; split.addArrangedSubview(scroll)
        details.maximumNumberOfLines = 5; details.font = .systemFont(ofSize:12); outer.addArrangedSubview(details); details.widthAnchor.constraint(equalTo:outer.widthAnchor).isActive = true
        let prev = NSButton(title:"← Предыдущий",target:self,action:#selector(previous)), next = NSButton(title:"Следующий →",target:self,action:#selector(nextImage)), fit = NSButton(title:"Вписать",target:self,action:#selector(fitImage)), full = NSButton(title:"Полный экран",target:self,action:#selector(fullscreen)), actual = NSButton(title:"100%",target:self,action:#selector(actualSize)), refresh = NSButton(title:"Обновить список",target:self,action:#selector(reloadAction))
        slideshow.target = self; slideshow.action = #selector(toggleSlideshow); for n in [0.5,1,2,3,5,10] { speed.addItem(withTitle:"\(n) с"); speed.lastItem?.representedObject = n }; speed.selectItem(at:2); speed.target = self; speed.action = #selector(speedChanged)
        let controls = NSStackView(views:[prev,next,fit,actual,full,slideshow,speed,refresh]); controls.spacing = 7; outer.addArrangedSubview(controls)
    }
    func reload() {
        stop(); generation += 1; let revision = generation; details.stringValue = "Читаю скачанные коллекции…"
        Task { let loaded = await engine.store.gallery(catalog:engine.catalog); guard generation == revision else { return }; all = loaded
            for (key,p) in filters { let selected = p.selectedItem?.representedObject as? String ?? "", title = p.itemTitle(at:0); let values = Set(all.flatMap(\.rules).map { $0.s(key) }.filter { !$0.isEmpty }).sorted(); p.removeAllItems(); p.addItem(withTitle:title); p.lastItem?.representedObject = ""; for v in values { p.addItem(withTitle:label(v,key:key)); p.lastItem?.representedObject = v }; if let i = p.itemArray.firstIndex(where:{ $0.representedObject as? String == selected }) { p.selectItem(at:i) } }
            applyFilters()
        }
    }
    func label(_ value: String, key: String) -> String {
        if key == "collection" { return engine.catalog.rows("collections").first { $0.s("id") == value }?.s("title") ?? value }
        let labels = ["winter":"Зима","spring":"Весна","summer":"Лето","autumn":"Осень","dawn":"Рассвет","day":"День","dusk":"Сумерки","night":"Ночь","none":"Без лунного варианта","new_moon":"Новолуние","waxing_crescent":"Растущий серп","first_quarter":"Первая четверть","waxing_gibbous":"Растущая Луна","full_moon":"Полнолуние","waning_gibbous":"Убывающая Луна","last_quarter":"Последняя четверть","waning_crescent":"Убывающий серп","clear":"Ясно","partly-cloudy":"Переменная облачность","overcast":"Пасмурно","fog":"Туман","drizzle":"Морось","rain":"Дождь","heavy-rain":"Сильный дождь","freezing-precipitation":"Ледяные осадки","snow":"Снег","heavy-snow":"Сильный снег","thunderstorm":"Гроза","severe-thunderstorm":"Сильная гроза","thunderstorm-hail":"Гроза с градом"]
        return labels[value] ?? value
    }
    func applyFilters() { let query = filters.mapValues { $0.selectedItem?.representedObject as? String ?? "" }; rows = all.filter { $0.matches(query) }; table.reloadData(); slideshow.isEnabled = rows.count > 1; if !rows.isEmpty { choose(0); show(0) } else { image.image = nil; shown = nil; details.stringValue = all.isEmpty ? "Скачанных изображений пока нет. Скачайте коллекцию в настройках." : "Нет изображений по выбранным условиям" } }
    func numberOfRows(in tableView:NSTableView) -> Int { rows.count }
    func tableView(_ tableView:NSTableView, viewFor tableColumn:NSTableColumn?, row:Int) -> NSView? {
        guard rows.indices.contains(row) else { return nil }; let r = rows[row], cell = NSTableCellView(), thumbnail = NSImageView(frame:NSRect(x:4,y:4,width:86,height:66)), text = NSTextField(wrappingLabelWithString:r.title)
        if let src = CGImageSourceCreateWithURL(r.url as CFURL,nil), let cg = CGImageSourceCreateThumbnailAtIndex(src,0,[kCGImageSourceCreateThumbnailFromImageAlways:true,kCGImageSourceThumbnailMaxPixelSize:180] as CFDictionary) { thumbnail.image = NSImage(cgImage:cg,size:.zero) }
        thumbnail.imageScaling = .scaleProportionallyUpOrDown; cell.addSubview(thumbnail); text.frame = NSRect(x:98,y:10,width:170,height:54); text.font = .systemFont(ofSize:11); cell.addSubview(text); return cell
    }
    func show(_ index: Int) {
        guard rows.indices.contains(index) else { return }; let row = rows[index]
        guard let bitmap = NSImage(contentsOf:row.url) else { stop(); details.stringValue = "Не удалось открыть изображение"; return }
        image.image = bitmap; image.frame = NSRect(x:0,y:0,width:row.file.n("width"),height:row.file.n("height")); shown = row.url; fitImage()
        let current = engine.displays.values.compactMap { d -> String? in guard let screen = d.screen, NSWorkspace.shared.desktopImageURL(for:screen)?.standardizedFileURL == row.url.standardizedFileURL else { return nil }; return d.title }
        let rules = row.rules.map { r in [r.s("season"),r.s("time_of_day"),r.s("weather"),r.s("moon_phase")].filter { !$0.isEmpty }.map { label($0,key:"") }.joined(separator:" · ") }
        details.stringValue = "\(index+1) / \(rows.count) · \(row.title) · \(Int(row.file.n("width")))×\(Int(row.file.n("height")))" + (current.isEmpty ? "" : "\nТекущие обои: " + current.joined(separator:", ")) + "\n" + Array(Set(rules)).sorted().prefix(3).joined(separator:"\n")
    }
    func choose(_ index: Int) { programmaticSelection = true; defer { programmaticSelection = false }; table.selectRowIndexes(IndexSet(integer:index),byExtendingSelection:false) }
    func tableViewSelectionDidChange(_ notification: Notification) { if !programmaticSelection { stop(); show(table.selectedRow) } }
    func advance(_ delta:Int, manual:Bool) { if manual { stop() }; guard !rows.isEmpty else { return }; let i = max(0,table.selectedRow), next = (i + delta + rows.count) % rows.count; choose(next); table.scrollRowToVisible(next); show(next) }
    func stop() { timer?.invalidate(); timer = nil; slideshow.title = "▶ Слайд-шоу" }
    func start() { stop(); guard rows.count > 1 else { return }; slideshow.title = "Ⅱ Остановить"; let seconds = speed.selectedItem?.representedObject as? Double ?? 2; timer = Timer.scheduledTimer(withTimeInterval:seconds,repeats:true) { [weak self] _ in Task { @MainActor in self?.advance(1,manual:false) } } }
    @objc func toggleSlideshow() { timer == nil ? start() : stop() }
    @objc func speedChanged() { if timer != nil { start() } }
    @objc func selectRow() { stop(); if rows.indices.contains(table.selectedRow) && shown != rows[table.selectedRow].url { show(table.selectedRow) } }
    @objc func filterChanged() { stop(); applyFilters() }
    @objc func previous() { advance(-1,manual:true) }
    @objc func nextImage() { advance(1,manual:true) }
    @objc func fullscreen() { window?.toggleFullScreen(nil) }
    @objc func actualSize() { scroll.magnification = 1 }
    @objc func fitImage() { guard image.frame.width > 0 && image.frame.height > 0 else { return }; window?.contentView?.layoutSubtreeIfNeeded(); scroll.magnification = max(0.01,min(16,min(scroll.contentSize.width/image.frame.width,scroll.contentSize.height/image.frame.height))) }
    @objc func reloadAction() { reload() }
    func windowWillClose(_ notification:Notification) { stop(); generation += 1 }
}

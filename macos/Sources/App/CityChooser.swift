import AppKit

@MainActor final class CityChooser: NSWindowController, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {
    let query = NSTextField(), table = NSTableView(), message = NSTextField(wrappingLabelWithString:"Введите название и выберите город в результатах.")
    let accept = NSButton(title:"Использовать город",target:nil,action:nil)
    let geo = NSButton(title:"Определить местоположение",target:nil,action:nil)
    let location = LocationService()
    var results: [JSON] = [], selected: JSON?, task: Task<Void,Never>?, generation = 0, finished = false
    let completion: (JSON?) -> Void
    init(completion: @escaping (JSON?) -> Void) {
        self.completion = completion
        let w = NSWindow(contentRect:NSRect(x:0,y:0,width:600,height:520),styleMask:[.titled,.closable],backing:.buffered,defer:false)
        w.title = "Погода в моём городе"; super.init(window:w); w.delegate = self; build()
    }
    required init?(coder:NSCoder) { nil }
    func build() {
        guard let content = window?.contentView else { return }
        let root = NSStackView(); root.orientation = .vertical; root.alignment = .leading; root.spacing = 14; root.translatesAutoresizingMaskIntoConstraints = false; content.addSubview(root)
        NSLayoutConstraint.activate([root.leadingAnchor.constraint(equalTo:content.leadingAnchor,constant:20),root.trailingAnchor.constraint(equalTo:content.trailingAnchor,constant:-20),root.topAnchor.constraint(equalTo:content.topAnchor,constant:20),root.bottomAnchor.constraint(equalTo:content.bottomAnchor,constant:-20)])
        func add(_ v: NSView) { root.addView(v,in:.top); v.widthAnchor.constraint(equalTo:root.widthAnchor).isActive = true }
        let title = NSTextField(labelWithString:"Город для Open-Meteo"); title.font = .systemFont(ofSize:17,weight:.semibold); add(title)
        query.placeholderString = "Название города"; query.target = self; query.action = #selector(search)
        let find = NSButton(title:"Найти",target:self,action:#selector(search)); let searchRow = NSStackView(views:[query,find]); searchRow.spacing = 8; add(searchRow)
        query.setContentHuggingPriority(.defaultLow,for:.horizontal)
        let column = NSTableColumn(identifier:NSUserInterfaceItemIdentifier("city")); column.title = "Город, регион, страна"; column.width = 540; table.addTableColumn(column)
        table.headerView = nil; table.rowHeight = 42; table.dataSource = self; table.delegate = self; table.allowsEmptySelection = true; table.allowsMultipleSelection = false
        let scroll = NSScrollView(); scroll.hasVerticalScroller = true; scroll.borderType = .bezelBorder; scroll.documentView = table; add(scroll)
        scroll.heightAnchor.constraint(greaterThanOrEqualToConstant:150).isActive = true
        message.font = .systemFont(ofSize:12); message.textColor = .secondaryLabelColor; message.maximumNumberOfLines = 3; add(message)
        geo.target = self; geo.action = #selector(locate); root.addView(geo,in:.top)
        let spacer = NSView(); spacer.setContentHuggingPriority(.defaultLow,for:.horizontal)
        let cancel = NSButton(title:"Отмена",target:self,action:#selector(cancel)); cancel.keyEquivalent = "\u{1b}"
        accept.target = self; accept.action = #selector(useCity); accept.isEnabled = false
        let buttons = NSStackView(views:[spacer,cancel,accept]); buttons.spacing = 8; add(buttons)
        window?.initialFirstResponder = query
    }
    func numberOfRows(in tableView: NSTableView) -> Int { results.count }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard results.indices.contains(row) else { return nil }
        let c = results[row], name = c.s("name"), region = [c.s("admin1"),c.s("country")].filter { !$0.isEmpty }.joined(separator:", ")
        let text = NSTextField(wrappingLabelWithString:name + (region.isEmpty ? "" : "\n" + region)); text.font = .systemFont(ofSize:12); text.maximumNumberOfLines = 2
        let cell = NSTableCellView(); cell.addSubview(text); text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([text.leadingAnchor.constraint(equalTo:cell.leadingAnchor,constant:8),text.trailingAnchor.constraint(equalTo:cell.trailingAnchor,constant:-8),text.centerYAnchor.constraint(equalTo:cell.centerYAnchor)])
        return cell
    }
    func tableViewSelectionDidChange(_ notification: Notification) {
        selected = results.indices.contains(table.selectedRow) ? results[table.selectedRow] : nil
        accept.isEnabled = selected != nil
        if let selected { message.stringValue = "\(selected.s("name")) · \(selected.s("timezone"))\nГород сохранится в настройках после нажатия «Применить»." }
    }
    func stop() { generation += 1; task?.cancel(); task = nil; location.cancel(); geo.isEnabled = true }
    @objc func search() {
        let q = query.stringValue.trimmingCharacters(in:.whitespacesAndNewlines)
        guard q.count >= 2 else { message.stringValue = "Введите хотя бы две буквы"; return }
        stop(); let revision = generation; selected = nil; accept.isEnabled = false; results = []; table.reloadData(); message.stringValue = "Поиск города…"
        task = Task { [weak self] in
            guard let self else { return }
            do {
                let found = try await LocationService.search(q); try Task.checkCancellation(); guard generation == revision, !finished else { return }
                results = found; table.reloadData(); message.stringValue = found.isEmpty ? "Город не найден. Попробуйте другое название." : "Выберите город в списке."
            } catch is CancellationError {} catch { if generation == revision, !finished { message.stringValue = error.localizedDescription } }
        }
    }
    @objc func locate() {
        stop(); let revision = generation; geo.isEnabled = false; selected = nil; accept.isEnabled = false; message.stringValue = "Определяю местоположение…"
        table.deselectAll(nil)
        task = Task { [weak self] in
            guard let self else { return }
            defer { if generation == revision { geo.isEnabled = true; task = nil } }
            do {
                let city = try await location.locate(); try Task.checkCancellation(); guard generation == revision, !finished else { return }
                results = [city]; table.reloadData(); table.selectRowIndexes(IndexSet(integer:0),byExtendingSelection:false)
                selected = city; accept.isEnabled = true; message.stringValue = "Местоположение определено. Часовой пояс: \(city.s("timezone"))."
            } catch is CancellationError {} catch { if generation == revision, !finished { message.stringValue = error.localizedDescription } }
        }
    }
    @objc func useCity() { guard let selected, (try? City(selected)) != nil else { return }; finish(selected) }
    @objc func cancel() { finish(nil) }
    func finish(_ city: JSON?) {
        guard !finished else { return }; finished = true; stop()
        if let w = window, let parent = w.sheetParent { parent.endSheet(w) }; window?.orderOut(nil); completion(city)
    }
    func windowShouldClose(_ sender: NSWindow) -> Bool { cancel(); return false }
}

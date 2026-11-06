package ru.oopssre.imperialschool.views

/** Remember phone availability, not every ID present in the site catalogue. */
internal object CollectionNotices {
    fun added(data: Catalogue, known: Set<String>?): List<Collection> =
        if(known==null) emptyList() else data.phoneCollections().filter { it.id !in known }

    fun observe(repo: Repository, data: Catalogue): List<Collection> {
        val initialized=repo.text("phone_collections_initialized")=="1"
        val known=repo.text("known_phone_collections").split('|').filter { it.isNotBlank() }.toSet()
        val added=added(data,known.takeIf { initialized })
        // Keep previous IDs through temporary catalogue removals. Old desktop IDs are never migrated.
        repo.put("known_phone_collections",(known+data.phoneCollections().map { it.id }).sorted().joinToString("|"))
        repo.put("phone_collections_initialized","1")
        return added
    }
}

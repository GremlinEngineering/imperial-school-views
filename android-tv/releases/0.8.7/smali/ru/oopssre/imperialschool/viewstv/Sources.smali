.class public final Lru/oopssre/imperialschool/viewstv/Sources;
.super Ljava/lang/Object;
.source "Sources.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static identity(Lorg/json/JSONObject;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 20
    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->isNull(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, ""

    return-object p0

    :cond_0
    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static mode(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 33
    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    const-string v0, "schedule"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p0

    const-string v0, "auto"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p1

    :cond_0
    if-eqz p0, :cond_1

    const-string p1, "monthly"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    return-object p1

    :cond_1
    if-eqz p0, :cond_2

    const-string p1, "seasonal"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_2

    return-object p1

    :cond_2
    const-string p0, "daily"

    return-object p0
.end method

.method public static ordinary(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;J)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 16
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 35
    const-string v2, "timezone"

    const-string v3, "local"

    invoke-virtual {v0, v2, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-static {}, Ljava/time/ZoneId;->systemDefault()Ljava/time/ZoneId;

    move-result-object v2

    goto :goto_0

    :cond_0
    invoke-static {v2}, Ljava/time/ZoneId;->of(Ljava/lang/String;)Ljava/time/ZoneId;

    move-result-object v2

    :goto_0
    invoke-static/range {p3 .. p4}, Ljava/time/Instant;->ofEpochMilli(J)Ljava/time/Instant;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/time/Instant;->atZone(Ljava/time/ZoneId;)Ljava/time/ZonedDateTime;

    move-result-object v3

    invoke-virtual {v3}, Ljava/time/ZonedDateTime;->toLocalDate()Ljava/time/LocalDate;

    move-result-object v3

    invoke-static/range {p1 .. p2}, Lru/oopssre/imperialschool/viewstv/Sources;->mode(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-wide/16 v5, 0x1

    invoke-virtual {v3, v5, v6}, Ljava/time/LocalDate;->plusDays(J)Ljava/time/LocalDate;

    move-result-object v7

    invoke-virtual {v7, v2}, Ljava/time/LocalDate;->atStartOfDay(Ljava/time/ZoneId;)Ljava/time/ZonedDateTime;

    move-result-object v7

    invoke-virtual {v7}, Ljava/time/ZonedDateTime;->toInstant()Ljava/time/Instant;

    move-result-object v7

    invoke-virtual {v7}, Ljava/time/Instant;->toEpochMilli()J

    move-result-wide v7

    .line 36
    const-string v9, "monthly"

    invoke-virtual {v4, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    const-string v11, "schedule"

    const/4 v12, 0x1

    if-eqz v10, :cond_1

    iget-object v4, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    invoke-virtual {v4, v11}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v4

    invoke-virtual {v4, v9}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v4

    invoke-virtual {v3}, Ljava/time/LocalDate;->getMonthValue()I

    move-result v7

    invoke-static {v7}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v12}, Ljava/time/LocalDate;->withDayOfMonth(I)Ljava/time/LocalDate;

    move-result-object v7

    invoke-virtual {v7, v5, v6}, Ljava/time/LocalDate;->plusMonths(J)Ljava/time/LocalDate;

    move-result-object v5

    invoke-virtual {v5, v2}, Ljava/time/LocalDate;->atStartOfDay(Ljava/time/ZoneId;)Ljava/time/ZonedDateTime;

    move-result-object v5

    invoke-virtual {v5}, Ljava/time/ZonedDateTime;->toInstant()Ljava/time/Instant;

    move-result-object v5

    invoke-virtual {v5}, Ljava/time/Instant;->toEpochMilli()J

    move-result-wide v7

    :goto_1
    move-wide v5, v7

    goto :goto_3

    .line 37
    :cond_1
    const-string v5, "seasonal"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_5

    invoke-virtual {v3}, Ljava/time/LocalDate;->getMonthValue()I

    move-result v4

    const/4 v6, 0x3

    if-lt v4, v6, :cond_2

    invoke-virtual {v3}, Ljava/time/LocalDate;->getMonthValue()I

    move-result v4

    const/4 v6, 0x5

    if-gt v4, v6, :cond_2

    const-string v4, "spring"

    goto :goto_2

    :cond_2
    invoke-virtual {v3}, Ljava/time/LocalDate;->getMonthValue()I

    move-result v4

    const/4 v6, 0x6

    if-lt v4, v6, :cond_3

    invoke-virtual {v3}, Ljava/time/LocalDate;->getMonthValue()I

    move-result v4

    const/16 v6, 0x8

    if-gt v4, v6, :cond_3

    const-string v4, "summer"

    goto :goto_2

    :cond_3
    invoke-virtual {v3}, Ljava/time/LocalDate;->getMonthValue()I

    move-result v4

    const/16 v6, 0x9

    if-lt v4, v6, :cond_4

    invoke-virtual {v3}, Ljava/time/LocalDate;->getMonthValue()I

    move-result v4

    const/16 v6, 0xb

    if-gt v4, v6, :cond_4

    const-string v4, "autumn"

    goto :goto_2

    :cond_4
    const-string v4, "winter"

    :goto_2
    iget-object v6, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    invoke-virtual {v6, v11}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v6

    invoke-virtual {v6, v5}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    invoke-virtual {v5, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    goto :goto_1

    .line 38
    :cond_5
    const-string v5, "daily"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    const-string v5, "\u041d\u0435\u0438\u0437\u0432\u0435\u0441\u0442\u043d\u044b\u0439 \u0440\u0435\u0436\u0438\u043c \u0441\u043c\u0435\u043d\u044b"

    invoke-static {v4, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const/4 v4, 0x0

    goto :goto_1

    .line 39
    :goto_3
    const-string v7, "items"

    invoke-virtual {v0, v7}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    new-instance v7, Ljava/util/ArrayList;

    invoke-direct {v7}, Ljava/util/ArrayList;-><init>()V

    const/4 v8, 0x0

    move v9, v8

    :goto_4
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v10

    if-ge v9, v10, :cond_8

    invoke-virtual {v0, v9}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v10

    const-string v11, "collection"

    invoke-virtual {v10, v11}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    iget-object v13, v1, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v11, v13}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_7

    if-eqz v4, :cond_6

    const-string v11, "id"

    invoke-virtual {v10, v11}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v11, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_7

    :cond_6
    invoke-interface {v7, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_7
    add-int/lit8 v9, v9, 0x1

    goto :goto_4

    :cond_8
    invoke-interface {v7}, Ljava/util/List;->isEmpty()Z

    move-result v0

    xor-int/2addr v0, v12

    const-string v9, "\u0412 \u043a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u0438 \u043d\u0435\u0442 \u0442\u0435\u043a\u0443\u0449\u0435\u0433\u043e \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f"

    invoke-static {v0, v9}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    if-nez v4, :cond_9

    invoke-virtual {v3}, Ljava/time/LocalDate;->toEpochDay()J

    move-result-wide v8

    invoke-interface {v7}, Ljava/util/List;->size()I

    move-result v0

    int-to-long v10, v0

    invoke-static {v8, v9, v10, v11}, Ljava/lang/Math;->floorMod(JJ)J

    move-result-wide v8

    long-to-int v8, v8

    :cond_9
    invoke-interface {v7, v8}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/json/JSONObject;

    .line 40
    const-string v4, "files"

    invoke-virtual {v0, v4}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v4

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/Sources;->picture(Lorg/json/JSONArray;)Lorg/json/JSONObject;

    move-result-object v4

    const-string v7, "title"

    invoke-virtual {v0, v7}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v2}, Ljava/time/LocalDate;->atStartOfDay(Ljava/time/ZoneId;)Ljava/time/ZonedDateTime;

    move-result-object v2

    invoke-virtual {v2}, Ljava/time/ZonedDateTime;->toInstant()Ljava/time/Instant;

    move-result-object v2

    invoke-virtual {v2}, Ljava/time/Instant;->toEpochMilli()J

    move-result-wide v2

    move-wide v14, v2

    move-object v2, v0

    move-object v0, v4

    move-wide v3, v14

    invoke-static/range {v0 .. v6}, Lru/oopssre/imperialschool/viewstv/Sources;->pictureFrame(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;JJ)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v0

    const-string v1, "plain"

    iput-object v1, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->kind:Ljava/lang/String;

    const-string v1, "none"

    iput-object v1, v0, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sourceId:Ljava/lang/String;

    return-object v0
.end method

.method static picture(Lorg/json/JSONArray;)Lorg/json/JSONObject;
    .locals 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    const/4 v0, 0x0

    const-wide v1, 0x7fefffffffffffffL    # Double.MAX_VALUE

    const/4 v3, 0x0

    move v4, v3

    .line 17
    :goto_0
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v5

    if-ge v4, v5, :cond_1

    invoke-virtual {p0, v4}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v5

    :try_start_0
    const-string v6, "format"

    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->canonical(Ljava/lang/String;)Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    const-string v6, "width"

    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v6

    const-string v7, "height"

    invoke-virtual {v5, v7}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v7

    if-lt v6, v7, :cond_0

    if-lez v6, :cond_0

    if-lez v7, :cond_0

    const/16 v8, 0x4000

    if-gt v6, v8, :cond_0

    if-gt v7, v8, :cond_0

    invoke-static {v6, v7}, Lru/oopssre/imperialschool/viewstv/Sources;->score(II)D

    move-result-wide v8

    cmpg-double v8, v8, v1

    if-gez v8, :cond_0

    invoke-static {v6, v7}, Lru/oopssre/imperialschool/viewstv/Sources;->score(II)D

    move-result-wide v0

    move-wide v1, v0

    move-object v0, v5

    :catch_0
    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_1
    if-eqz v0, :cond_2

    const/4 v3, 0x1

    :cond_2
    const-string p0, "\u041d\u0435\u0442 \u0433\u043e\u0440\u0438\u0437\u043e\u043d\u0442\u0430\u043b\u044c\u043d\u043e\u0433\u043e \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f"

    invoke-static {v3, p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    return-object v0
.end method

.method static pictureFrame(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;JJ)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 18
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v6, p1

    .line 18
    const-string v1, "format"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->canonical(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "url"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v2, "sha256"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-static {v7}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->fromURL(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const-string v2, "\u0420\u0430\u0441\u0448\u0438\u0440\u0435\u043d\u0438\u0435 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u044f \u043d\u0435 \u0441\u043e\u0432\u043f\u0430\u043b\u043e \u0441 \u0444\u043e\u0440\u043c\u0430\u0442\u043e\u043c"

    invoke-static {v1, v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const-wide/16 v2, 0x1

    const-wide/32 v4, 0x2000000

    const-string v1, "bytes"

    invoke-static/range {v0 .. v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->integer(Lorg/json/JSONObject;Ljava/lang/String;JJ)J

    move-result-wide v12

    iget-object v1, v6, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-static {v7, v1}, Lru/oopssre/imperialschool/viewstv/Sources;->pictureURL(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-static {v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->hash(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    const-string v2, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435 \u043a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u0438"

    invoke-static {v1, v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v3, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    iget-object v4, v6, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    iget-object v5, v6, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    const-string v1, "width"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v10

    const-string v1, "height"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v11

    move-object v9, v8

    move-object/from16 v6, p2

    move-wide/from16 v14, p3

    move-wide/from16 v16, p5

    invoke-direct/range {v3 .. v17}, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IIJJJ)V

    return-object v3
.end method

.method public static pictureURL(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 2

    .line 16
    invoke-static {p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->url(Ljava/lang/String;)Ljava/net/URI;

    move-result-object p0

    invoke-virtual {p0}, Ljava/net/URI;->getPath()Ljava/lang/String;

    move-result-object p0

    const-string v0, "/assets/arcade/views/"

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "(?:collections/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p1}, Ljava/util/regex/Pattern;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, "/)?files/[a-zA-Z0-9_-]+\\.(?:jpe?g|png)"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static score(II)D
    .locals 6

    int-to-double v0, p0

    int-to-double p0, p1

    div-double v2, v0, p0

    const-wide v4, 0x3ffc71c71c71c71cL    # 1.7777777777777777

    div-double/2addr v2, v4

    .line 10
    invoke-static {v2, v3}, Ljava/lang/Math;->log(D)D

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Math;->abs(D)D

    move-result-wide v2

    const-wide/high16 v4, 0x4059000000000000L    # 100.0

    mul-double/2addr v2, v4

    mul-double/2addr v0, p0

    const-wide p0, 0x415fa40000000000L    # 8294400.0

    div-double/2addr v0, p0

    invoke-static {v0, v1}, Ljava/lang/Math;->log(D)D

    move-result-wide p0

    invoke-static {p0, p1}, Ljava/lang/Math;->abs(D)D

    move-result-wide p0

    add-double/2addr v2, p0

    return-wide v2
.end method

.method public static source(Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;)Lorg/json/JSONObject;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 19
    iget-object v0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->descriptor:Lorg/json/JSONObject;

    const-string v1, "sources"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-ge v2, v3, :cond_5

    invoke-virtual {v0, v2}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v3

    const-string v4, "id"

    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_0

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    const-string v0, "real"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v2, "game-world"

    const/4 v4, 0x1

    if-nez v0, :cond_2

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_1

    :cond_1
    move v0, v1

    goto :goto_2

    :cond_2
    :goto_1
    move v0, v4

    :goto_2
    const-string v5, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0438\u0441\u0442\u043e\u0447\u043d\u0438\u043a \u043f\u043e\u0433\u043e\u0434\u044b"

    invoke-static {v0, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v5, "weather/"

    invoke-direct {v0, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v5, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v5, "/"

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    const-string p1, "sources/game-world/"

    goto :goto_3

    :cond_3
    const-string p1, ""

    :goto_3
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "current_url"

    invoke-virtual {v3, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, "current.json"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->endpoint(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, "forecasts"

    invoke-virtual {v3, v0}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    iget-object v2, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, "forecast-"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-object p0, p0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, ".json"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->endpoint(Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_4

    move v1, v4

    :cond_4
    const-string p0, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0430\u0434\u0440\u0435\u0441 \u043f\u043e\u0433\u043e\u0434\u043d\u043e\u0433\u043e \u0438\u0441\u0442\u043e\u0447\u043d\u0438\u043a\u0430"

    invoke-static {v1, p0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    return-object v3

    :cond_5
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "\u0418\u0441\u0442\u043e\u0447\u043d\u0438\u043a \u043f\u043e\u0433\u043e\u0434\u044b \u043d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u0435\u043d"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static theme(Lorg/json/JSONObject;Lorg/json/JSONObject;)Lru/oopssre/imperialschool/viewstv/Protocol$Theme;
    .locals 19
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    move-object/from16 v7, p0

    .line 12
    const-string v0, "id"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v0, "title"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v0, "[a-z0-9][a-z0-9_-]{0,79}"

    invoke-virtual {v1, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v5, 0x12c

    if-gt v0, v5, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    const-string v5, "\u041d\u0435\u0432\u0435\u0440\u043d\u0430\u044f \u043a\u043e\u043b\u043b\u0435\u043a\u0446\u0438\u044f"

    invoke-static {v0, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 13
    const-string v0, "type"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v5, "weather"

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v5, "height"

    const-string v6, "width"

    const/4 v8, 0x0

    if-eqz v0, :cond_5

    const-string v0, "formats"

    invoke-virtual {v7, v0}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v9

    const-wide v10, 0x7fefffffffffffffL    # Double.MAX_VALUE

    const/4 v12, 0x0

    const/4 v13, 0x0

    :goto_1
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v14

    if-eqz v14, :cond_3

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/String;

    invoke-virtual {v0, v14}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v15

    invoke-virtual {v15, v6}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v15, v5}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v15

    invoke-static {v14}, Lru/oopssre/imperialschool/viewstv/Protocol;->id(Ljava/lang/String;)Z

    move-result v16

    if-eqz v16, :cond_1

    if-lez v3, :cond_1

    if-lez v15, :cond_1

    const/16 v4, 0x4000

    if-gt v3, v4, :cond_1

    if-gt v15, v4, :cond_1

    const/4 v4, 0x1

    goto :goto_2

    :cond_1
    const/4 v4, 0x0

    :goto_2
    move-object/from16 p1, v0

    const-string v0, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u043f\u043e\u0433\u043e\u0434\u043d\u044b\u0439 \u0444\u043e\u0440\u043c\u0430\u0442"

    invoke-static {v4, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    if-lt v3, v15, :cond_2

    invoke-static {v3, v15}, Lru/oopssre/imperialschool/viewstv/Sources;->score(II)D

    move-result-wide v17

    cmpg-double v0, v17, v10

    if-gez v0, :cond_2

    invoke-static {v3, v15}, Lru/oopssre/imperialschool/viewstv/Sources;->score(II)D

    move-result-wide v10

    move v12, v3

    move-object v8, v14

    move v13, v15

    :cond_2
    move-object/from16 v0, p1

    goto :goto_1

    :cond_3
    if-eqz v8, :cond_4

    const/4 v3, 0x1

    goto :goto_3

    :cond_4
    const/4 v3, 0x0

    :goto_3
    const-string v0, "\u041d\u0435\u0442 \u0433\u043e\u0440\u0438\u0437\u043e\u043d\u0442\u0430\u043b\u044c\u043d\u043e\u0433\u043e \u043f\u043e\u0433\u043e\u0434\u043d\u043e\u0433\u043e \u0444\u043e\u0440\u043c\u0430\u0442\u0430"

    invoke-static {v3, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    const-string v3, "current_url"

    invoke-virtual {v7, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    move-object v3, v8

    move v5, v12

    move v6, v13

    invoke-direct/range {v0 .. v7}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILorg/json/JSONObject;)V

    return-object v0

    .line 14
    :cond_5
    const-string v0, "items"

    move-object/from16 v3, p1

    invoke-virtual {v3, v0}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    const/4 v3, 0x0

    :goto_4
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-ge v3, v4, :cond_7

    invoke-virtual {v0, v3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v4

    const-string v7, "collection"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_6

    :try_start_0
    const-string v7, "files"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v4

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/Sources;->picture(Lorg/json/JSONArray;)Lorg/json/JSONObject;

    move-result-object v8
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_5

    :catch_0
    :cond_6
    add-int/lit8 v3, v3, 0x1

    goto :goto_4

    :cond_7
    :goto_5
    if-eqz v8, :cond_8

    const/4 v3, 0x1

    goto :goto_6

    :cond_8
    const/4 v3, 0x0

    :goto_6
    const-string v0, "\u041d\u0435\u0442 \u0433\u043e\u0440\u0438\u0437\u043e\u043d\u0442\u0430\u043b\u044c\u043d\u044b\u0445 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0439"

    invoke-static {v3, v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    new-instance v0, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;

    invoke-virtual {v8, v6}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v8, v5}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v6

    move v5, v3

    const-string v3, "plain"

    const-string v4, ""

    move-object/from16 v7, p0

    invoke-direct/range {v0 .. v7}, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IILorg/json/JSONObject;)V

    return-object v0
.end method

.method public static weather(Lorg/json/JSONObject;Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;J)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;
    .locals 21
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v3, p2

    move-object/from16 v9, p3

    .line 22
    const-string v2, "schema"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v4

    const-string v5, "source_id"

    const-string v6, "collection_id"

    const-string v10, "weather"

    const/4 v7, 0x0

    const/4 v8, 0x1

    if-ne v4, v8, :cond_0

    const-string v4, "type"

    invoke-virtual {v0, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_0

    invoke-virtual {v0, v6}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iget-object v11, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v4, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_0

    invoke-virtual {v0, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_0

    move v4, v8

    goto :goto_0

    :cond_0
    move v4, v7

    :goto_0
    const-string v11, "\u041d\u0435\u0432\u0435\u0440\u043d\u0430\u044f \u0442\u0435\u043a\u0443\u0449\u0430\u044f \u043f\u043e\u0433\u043e\u0434\u0430"

    invoke-static {v4, v11}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 23
    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v2

    const-string v4, "format"

    if-ne v2, v8, :cond_1

    const-string v2, "document_type"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v11, "weather-forecast"

    invoke-virtual {v2, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v1, v6}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iget-object v6, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->id:Ljava/lang/String;

    invoke-virtual {v2, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v1, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v1, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iget-object v5, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v2, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    move v2, v8

    goto :goto_1

    :cond_1
    move v2, v7

    :goto_1
    const-string v5, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u043f\u043e\u0433\u043e\u0434\u043d\u044b\u0439 \u043f\u0440\u043e\u0433\u043d\u043e\u0437"

    invoke-static {v2, v5}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const/4 v2, 0x3

    .line 24
    new-array v5, v2, [Ljava/lang/String;

    const-string v6, "world_id"

    aput-object v6, v5, v7

    const-string v6, "location_revision"

    aput-object v6, v5, v8

    const/4 v11, 0x2

    const-string v12, "timezone"

    aput-object v12, v5, v11

    move v13, v7

    :goto_2
    if-ge v13, v2, :cond_2

    aget-object v14, v5, v13

    invoke-static {v0, v14}, Lru/oopssre/imperialschool/viewstv/Sources;->identity(Lorg/json/JSONObject;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v15

    invoke-static {v1, v14}, Lru/oopssre/imperialschool/viewstv/Sources;->identity(Lorg/json/JSONObject;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v15, v14}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v14

    const-string v15, "\u041f\u043e\u0433\u043e\u0434\u043d\u044b\u0439 \u043c\u0438\u0440 \u0438\u043b\u0438 \u043c\u0435\u0441\u0442\u043e \u0438\u0437\u043c\u0435\u043d\u0438\u043b\u0438\u0441\u044c: \u043f\u043e\u0432\u0442\u043e\u0440\u044e \u043f\u043e\u043b\u0443\u0447\u0435\u043d\u0438\u0435"

    invoke-static {v14, v15}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    add-int/lit8 v13, v13, 0x1

    goto :goto_2

    .line 25
    :cond_2
    invoke-virtual {v0, v12}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Ljava/time/ZoneId;->of(Ljava/lang/String;)Ljava/time/ZoneId;

    invoke-virtual {v0, v6}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_3

    invoke-virtual {v1, v6}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_3

    move v5, v8

    goto :goto_3

    :cond_3
    move v5, v7

    :goto_3
    const-string v6, "\u041d\u0435\u0442 \u0440\u0435\u0432\u0438\u0437\u0438\u0438 \u043c\u0435\u0441\u0442\u0430"

    invoke-static {v5, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const/4 v5, 0x4

    .line 26
    new-array v5, v5, [Ljava/lang/String;

    const-string v6, "ready"

    aput-object v6, v5, v7

    const-string v12, "not_ready"

    aput-object v12, v5, v8

    const-string v12, "stale"

    aput-object v12, v5, v11

    const-string v11, "unresolved_weather"

    aput-object v11, v5, v2

    invoke-static {v5}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v2

    const-string v5, "status"

    invoke-virtual {v0, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-interface {v2, v11}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-virtual {v1, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v11, "unavailable"

    invoke-virtual {v2, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_4

    move v2, v8

    goto :goto_4

    :cond_4
    move v2, v7

    :goto_4
    const-string v11, "\u041f\u043e\u0433\u043e\u0434\u043d\u044b\u0435 \u0434\u0430\u043d\u043d\u044b\u0435 \u043f\u043e\u043a\u0430 \u043d\u0435\u0434\u043e\u0441\u0442\u0443\u043f\u043d\u044b"

    invoke-static {v2, v11}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 27
    const-string v2, "generated_at"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v11

    const-string v2, "valid_until"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    invoke-static {v13}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v13

    cmp-long v11, v11, p4

    if-gtz v11, :cond_5

    cmp-long v11, p4, v13

    if-gez v11, :cond_5

    move v11, v8

    goto :goto_5

    :cond_5
    move v11, v7

    :goto_5
    const-string v12, "\u041f\u0440\u043e\u0433\u043d\u043e\u0437 \u0443\u0441\u0442\u0430\u0440\u0435\u043b"

    invoke-static {v11, v12}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 28
    const-string v11, "intervals"

    invoke-virtual {v1, v11}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v11

    invoke-virtual {v11}, Lorg/json/JSONArray;->length()I

    move-result v12

    const/16 v15, 0x7d0

    if-gt v12, v15, :cond_6

    move v12, v8

    goto :goto_6

    :cond_6
    move v12, v7

    :goto_6
    const-string v15, "\u041f\u0440\u043e\u0433\u043d\u043e\u0437 \u0441\u043b\u0438\u0448\u043a\u043e\u043c \u0431\u043e\u043b\u044c\u0448\u043e\u0439"

    invoke-static {v12, v15}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const/4 v12, 0x0

    move v15, v7

    :goto_7
    invoke-virtual {v11}, Lorg/json/JSONArray;->length()I

    move-result v7

    const-string v8, "valid_from"

    if-ge v15, v7, :cond_a

    invoke-virtual {v11, v15}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v7

    invoke-virtual {v7, v8}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-static {v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v16

    invoke-virtual {v7, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-static {v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v18

    cmp-long v8, v18, v16

    if-lez v8, :cond_7

    const/4 v8, 0x1

    goto :goto_8

    :cond_7
    const/4 v8, 0x0

    :goto_8
    move-object/from16 v20, v7

    const-string v7, "\u041d\u0435\u0432\u0435\u0440\u043d\u044b\u0439 \u0438\u043d\u0442\u0435\u0440\u0432\u0430\u043b \u043f\u0440\u043e\u0433\u043d\u043e\u0437\u0430"

    invoke-static {v8, v7}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    cmp-long v7, v16, p4

    if-gtz v7, :cond_9

    cmp-long v7, p4, v18

    if-gez v7, :cond_9

    if-nez v12, :cond_8

    const/4 v7, 0x1

    goto :goto_9

    :cond_8
    const/4 v7, 0x0

    :goto_9
    const-string v8, "\u041f\u0435\u0440\u0435\u0441\u0435\u043a\u0430\u044e\u0449\u0438\u0435\u0441\u044f \u0438\u043d\u0442\u0435\u0440\u0432\u0430\u043b\u044b \u043f\u0440\u043e\u0433\u043d\u043e\u0437\u0430"

    invoke-static {v7, v8}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    move-object/from16 v12, v20

    :cond_9
    add-int/lit8 v15, v15, 0x1

    const/4 v8, 0x1

    goto :goto_7

    :cond_a
    if-eqz v12, :cond_b

    .line 29
    invoke-virtual {v12, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_b

    const/4 v5, 0x1

    goto :goto_a

    :cond_b
    const/4 v5, 0x0

    :goto_a
    const-string v6, "\u0422\u0435\u043a\u0443\u0449\u0438\u0439 \u043f\u043e\u0433\u043e\u0434\u043d\u044b\u0439 \u043a\u0430\u0434\u0440 \u0435\u0449\u0451 \u043d\u0435 \u0433\u043e\u0442\u043e\u0432"

    invoke-static {v5, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const-string v5, "state_id"

    invoke-virtual {v12, v5}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_c

    const-string v5, "moon_phase"

    invoke-virtual {v12, v5}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_c

    const/4 v5, 0x1

    goto :goto_b

    :cond_c
    const/4 v5, 0x0

    :goto_b
    const-string v6, "\u041d\u0435\u0442 \u0441\u043e\u0441\u0442\u043e\u044f\u043d\u0438\u044f \u043f\u043e\u0433\u043e\u0434\u043d\u043e\u0433\u043e \u043a\u0430\u0434\u0440\u0430"

    invoke-static {v5, v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    const-string v5, "file"

    invoke-virtual {v12, v5}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    const-string v6, "url"

    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->fromURL(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lru/oopssre/imperialschool/viewstv/ImageFormat;->canonical(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v6, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_d

    const-string v4, "rendition"

    invoke-virtual {v5, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iget-object v6, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->device:Ljava/lang/String;

    invoke-virtual {v4, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_d

    const-string v4, "width"

    invoke-virtual {v5, v4}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v4

    iget v6, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->width:I

    if-ne v4, v6, :cond_d

    const-string v4, "height"

    invoke-virtual {v5, v4}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v4

    iget v6, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->height:I

    if-ne v4, v6, :cond_d

    const/4 v7, 0x1

    goto :goto_c

    :cond_d
    const/4 v7, 0x0

    :goto_c
    const-string v4, "\u041d\u0435\u0432\u0435\u0440\u043d\u043e\u0435 \u043f\u043e\u0433\u043e\u0434\u043d\u043e\u0435 \u0438\u0437\u043e\u0431\u0440\u0430\u0436\u0435\u043d\u0438\u0435"

    invoke-static {v7, v4}, Lru/oopssre/imperialschool/viewstv/Protocol;->require(ZLjava/lang/String;)V

    .line 30
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v6, v3, Lru/oopssre/imperialschool/viewstv/Protocol$Theme;->title:Ljava/lang/String;

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, " \u00b7 "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, "real"

    invoke-virtual {v9, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_e

    const-string v6, "\u041f\u043e\u0433\u043e\u0434\u0430 \u0421\u0442\u043e\u043b\u0438\u0446\u044b \u0418\u043c\u043f\u0435\u0440\u0438\u0438"

    goto :goto_d

    :cond_e
    const-string v6, "\u0418\u0433\u0440\u043e\u0432\u043e\u0439 \u043c\u0438\u0440"

    :goto_d
    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v12, v8}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v6

    invoke-virtual {v12, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v11

    invoke-static {v13, v14, v11, v12}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v11

    move-object v2, v5

    move-wide v5, v6

    move-wide v7, v11

    invoke-static/range {v2 .. v8}, Lru/oopssre/imperialschool/viewstv/Sources;->pictureFrame(Lorg/json/JSONObject;Lru/oopssre/imperialschool/viewstv/Protocol$Theme;Ljava/lang/String;JJ)Lru/oopssre/imperialschool/viewstv/Protocol$Frame;

    move-result-object v2

    iput-object v10, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->kind:Ljava/lang/String;

    iput-object v9, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->sourceId:Ljava/lang/String;

    .line 31
    iget-wide v3, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->until:J

    const-string v5, "refresh_after"

    invoke-virtual {v0, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v6

    invoke-virtual {v1, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lru/oopssre/imperialschool/viewstv/Protocol;->time(Ljava/lang/String;)J

    move-result-wide v0

    invoke-static {v6, v7, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    invoke-static {v3, v4, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    iput-wide v0, v2, Lru/oopssre/imperialschool/viewstv/Protocol$Frame;->refreshAt:J

    return-object v2
.end method

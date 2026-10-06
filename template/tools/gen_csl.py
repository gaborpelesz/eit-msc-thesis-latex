# Generates template/biblatex-numeric-{en,hu}.csl. Run from the repository root:
#   python3 template/tools/gen_csl.py
L = {
  "en": dict(name="English", locale="en-US", lang="en", oq="“", cq="”", ed_s="ed.", ed_m="eds.",
             etal="et al.", and_="and", dpl="contextual",
             months=["Jan.","Feb.","Mar.","Apr.","May","June","July","Aug.","Sept.","Oct.","Nov.","Dec."],
             in_='<text value="In:"/>',
             urldate='<date variable="accessed" prefix="(visited on " suffix=")"><date-part name="month" form="numeric-leading-zeros" suffix="/"/><date-part name="day" form="numeric-leading-zeros" suffix="/"/><date-part name="year"/></date>', edby_after_in="ed. by ", edby="Ed. by ",
             vol='<group delimiter=" "><text value="Vol."/><text variable="volume"/></group>',
             pages='<group delimiter=" "><label variable="page" form="short"/><text variable="page"/></group>',
             chap='<group delimiter=" "><text value="Chap."/><text variable="chapter-number"/></group>',
             artdate='<date variable="issued" prefix="(" suffix=")" delimiter=" "><date-part name="month" form="short"/><date-part name="year"/></date>',
             date='<date variable="issued" delimiter=" "><date-part name="month" form="short"/><date-part name="year"/></date>'),
  "hu": dict(name="Hungarian", locale="hu-HU", lang="hu", oq="„", cq="”", ed_s="szerk.", ed_m="szerk.",
             etal="és tsai.", and_="és", dpl="never",
             months=["jan.","febr.","márc.","ápr.","máj.","jún.","júl.","aug.","szept.","okt.","nov.","dec."],
             in_='',
             urldate='<date variable="accessed" prefix="(elérés dátuma " suffix=")"><date-part name="year" suffix=". "/><date-part name="month" form="numeric-leading-zeros" suffix=". "/><date-part name="day" form="numeric-leading-zeros" suffix="."/></date>', edby_after_in="Szerk. ", edby="Szerk. ",
             vol='<group delimiter=" "><text variable="volume" suffix="."/><text value="köt."/></group>',
             pages='<group delimiter=" "><text variable="page" suffix="."/><text value="old."/></group>',
             chap='<group delimiter=" "><text variable="chapter-number"/><text value="fej."/></group>',
             artdate='<date variable="issued" prefix="(" suffix=")"><date-part name="year"/><date-part name="month" form="short" prefix=". "/></date>',
             date='<date variable="issued"><date-part name="year"/><date-part name="month" form="short" prefix=". "/></date>'),
}

T = '''<?xml version="1.0" encoding="utf-8"?>
<!--
  Approximation of biblatex's `numeric` style (bibstyle `standard`,
  sorting=none, maxnames=3) as used by elteikthesis v2.4, {name}.
  Generated; part of the Typst port of elteikthesis (MIT licence).
  Entry layouts follow biblatex's standard.bbx drivers (article, book,
  inproceedings, incollection, thesis/report/misc).
-->
<style xmlns="http://purl.org/net/xbiblio/csl" class="in-text" version="1.0" demote-non-dropping-particle="never" default-locale="{locale}">
  <info>
    <title>elteikthesis biblatex numeric ({name})</title>
    <id>elteikthesis-biblatex-numeric-{lang}</id>
    <updated>2026-10-06T00:00:00+00:00</updated>
  </info>
  <locale xml:lang="{lang}">
    <style-options punctuation-in-quote="false"/>
    <terms>
      <term name="open-quote">{oq}</term>
      <term name="close-quote">{cq}</term>
      <term name="editor" form="short">
        <single>{ed_s}</single>
        <multiple>{ed_m}</multiple>
      </term>
      <term name="et-al">{etal}</term>
      <term name="and">{and_}</term>
      <term name="page" form="short">
        <single>p.</single>
        <multiple>pp.</multiple>
      </term>
{months}    </terms>
  </locale>
  <macro name="names-author">
    <names variable="author">
      <name and="text" delimiter=", " delimiter-precedes-last="{dpl}" et-al-min="4" et-al-use-first="1" initialize="false"/>
      <substitute>
        <names variable="editor">
          <name and="text" delimiter=", " delimiter-precedes-last="{dpl}" et-al-min="4" et-al-use-first="1" initialize="false"/>
          <label form="short" prefix=", "/>
        </names>
      </substitute>
    </names>
  </macro>
  <macro name="ed-by">
    <names variable="editor" prefix="{edby}">
      <name and="text" delimiter=", " delimiter-precedes-last="{dpl}" et-al-min="4" et-al-use-first="1" initialize="false"/>
    </names>
  </macro>
  <macro name="ed-by-after-in">
    <names variable="editor" prefix="{edby_after_in}">
      <name and="text" delimiter=", " delimiter-precedes-last="{dpl}" et-al-min="4" et-al-use-first="1" initialize="false"/>
    </names>
  </macro>
  <!-- In: Booktitle. Ed. by X  /  In: ed. by X (no booktitle) -->
  <macro name="in-container">
    <choose>
      <if variable="container-title">
        <group delimiter=". ">
          <group delimiter=" ">
            {in_}
            <text variable="container-title" font-style="italic"/>
          </group>
          <text macro="ed-by"/>
        </group>
      </if>
      <else-if variable="editor">
        <group delimiter=" ">
          {in_}
          <text macro="ed-by-after-in"/>
        </group>
      </else-if>
    </choose>
  </macro>
  <macro name="journal">
    <group delimiter=" ">
      {in_}
      <text variable="container-title" font-style="italic"/>
      <group delimiter=".">
        <text variable="volume"/>
        <text variable="issue"/>
      </group>
      {artdate}
    </group>
  </macro>
  <!-- italic title followed by its period inside the italic run, so the
       template can drop the period after a title ending in ! or ? -->
  <macro name="title-italic">
    <text variable="title" font-style="italic" suffix="."/>
  </macro>
  <macro name="volume">{vol}</macro>
  <!-- series + number; hayagriva passes a @book/@incollection/@inproceedings
       `number` as `issue` -->
  <macro name="series">
    <group delimiter=" ">
      <text variable="collection-title"/>
      <text variable="collection-number"/>
      <text variable="issue"/>
    </group>
  </macro>
  <!-- biblatex organization+location+date: "Location: Organization, Date" -->
  <macro name="organization-date">
    <group delimiter=", ">
      <group delimiter=": ">
        <text variable="publisher-place"/>
        <text variable="authority"/>
      </group>
      <text macro="date"/>
    </group>
  </macro>
  <macro name="pages">{pages}</macro>
  <macro name="date">{date}</macro>
  <macro name="publisher-place-publisher">
    <group delimiter=": ">
      <text variable="publisher-place"/>
      <text variable="publisher"/>
    </group>
  </macro>
  <!-- location: publisher, date -->
  <macro name="publisher-date">
    <group delimiter=", ">
      <group delimiter=": ">
        <text variable="publisher-place"/>
        <text variable="publisher"/>
      </group>
      <text macro="date"/>
    </group>
  </macro>
  <macro name="identifiers">
    <group delimiter=". ">
      <group delimiter=": ">
        <text value="isbn" font-variant="small-caps"/>
        <text variable="ISBN"/>
      </group>
      <group delimiter=": ">
        <text value="issn" font-variant="small-caps"/>
        <text variable="ISSN"/>
      </group>
      <group delimiter=": ">
        <text value="doi" font-variant="small-caps"/>
        <text variable="DOI"/>
      </group>
      <group delimiter=" ">
        <group delimiter=": ">
          <text value="url" font-variant="small-caps"/>
          <text variable="URL"/>
        </group>
        {urldate}
      </group>
    </group>
  </macro>
  <citation collapse="citation-number">
    <sort>
      <key variable="citation-number"/>
    </sort>
    <layout prefix="[" suffix="]" delimiter=", ">
      <text variable="citation-number"/>
    </layout>
  </citation>
  <bibliography second-field-align="flush" entry-spacing="0">
    <layout suffix=".">
      <text variable="citation-number" prefix="[" suffix="]"/>
      <group delimiter=". ">
        <text macro="names-author"/>
        <choose>
          <if type="book" match="any">
            <group delimiter=" ">
              <text macro="title-italic"/>
              <group delimiter=". ">
              <text variable="edition"/>
              <text macro="volume"/>
              <text macro="series"/>
              <text variable="note"/>
              <text macro="publisher-date"/>
              </group>
            </group>
          </if>
          <else-if type="article-journal article-magazine article-newspaper article" match="any">
            <group delimiter=". ">
              <text variable="title" quotes="true"/>
              <choose>
                <if variable="note">
                  <group delimiter=". ">
                    <text macro="journal"/>
                    <group delimiter=", ">
                      <text variable="note"/>
                      <text macro="pages"/>
                    </group>
                  </group>
                </if>
                <else>
                  <group delimiter=", ">
                    <text macro="journal"/>
                    <text macro="pages"/>
                  </group>
                </else>
              </choose>
            </group>
          </else-if>
          <else-if type="paper-conference" match="any">
            <!-- inproceedings -->
            <group delimiter=". ">
              <text variable="title" quotes="true"/>
              <text macro="in-container"/>
              <text macro="volume"/>
              <text macro="series"/>
              <text variable="note"/>
              <text variable="authority"/>
              <group delimiter=", ">
                <text macro="publisher-date"/>
                <text macro="pages"/>
              </group>
            </group>
          </else-if>
          <else-if type="chapter entry-encyclopedia entry-dictionary" match="any">
            <!-- incollection -->
            <group delimiter=". ">
              <text variable="title" quotes="true"/>
              <text macro="in-container"/>
              <text macro="volume"/>
              <text macro="series"/>
              <text variable="note"/>
              <choose>
                <if variable="chapter-number">
                  <group delimiter=". ">
                    <text macro="publisher-date"/>
                    <group delimiter=", ">
                      {chap}
                      <text macro="pages"/>
                    </group>
                  </group>
                </if>
                <else>
                  <group delimiter=", ">
                    <text macro="publisher-date"/>
                    <text macro="pages"/>
                  </group>
                </else>
              </choose>
            </group>
          </else-if>
          <else-if type="thesis" match="any">
            <!-- thesis: "Title". Note. Type. Institution, Date (biblatex
                 quotes thesis titles) -->
            <group delimiter=". ">
              <text variable="title" quotes="true"/>
              <text variable="note"/>
              <text variable="genre"/>
              <group delimiter=", ">
                <text variable="authority"/>
                <text macro="publisher-place-publisher"/>
                <text macro="date"/>
              </group>
            </group>
          </else-if>
          <else-if type="report" match="any">
            <group delimiter=" ">
              <text macro="title-italic"/>
              <group delimiter=". ">
              <text variable="genre"/>
              <text variable="note"/>
              <group delimiter=", ">
                <text variable="authority"/>
                <text macro="publisher-place-publisher"/>
                <text macro="date"/>
              </group>
              </group>
            </group>
          </else-if>
          <else>
            <!-- online, misc, software (biblatex @misc driver; @software is
                 its alias): Title. Howpublished/Note. Location: Organization,
                 Date. No publisher. hayagriva passes `howpublished` as `note`
                 when the entry has no note of its own. -->
            <group delimiter=" ">
              <text macro="title-italic"/>
              <group delimiter=". ">
              <text variable="genre"/>
              <text variable="container-title" font-style="italic"/>
              <text variable="note"/>
              <text macro="organization-date"/>
              <text macro="pages"/>
              </group>
            </group>
          </else>
        </choose>
        <text macro="identifiers"/>
      </group>
    </layout>
  </bibliography>
</style>
'''

for k, d in L.items():
    d = dict(d)
    d["months"] = "".join(f'      <term name="month-{i:02d}" form="short">{m}</term>\n' for i, m in enumerate(d["months"], 1))
    open(f"template/biblatex-numeric-{k}.csl", "w").write(T.format(**d))

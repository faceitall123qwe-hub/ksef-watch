<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tns="http://crd.gov.pl/wzor/2025/06/25/13775/" version="1.0"><xsl:param name="nazwy-dla-kodow" select="false()"/>
	<xsl:param name="schema-krajow" select="'http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2022/01/05/eD/DefinicjeTypy/KodyKrajow_v10-0E.xsd'"/>
	<xsl:param name="schema-urzedow" select="'http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2022/01/05/eD/KodyUrzedowSkarbowych/KodyUrzedowSkarbowych_v8-0E.xsd'"/>
	<xsl:param name="schema-urzedowexwus" select="'http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2021/12/23/eD/KodyUrzedowSkarbowychExWUS/KodyUrzedowSkarbowychExWUS_v8-0E.xsd'"/>
	<xsl:param name="schema-naczelnikow-urzedow" select="'http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2017/02/06/eD/KodyNaczelnikowUrzedowSkarbowych/KodyNaczelnikowUrzedowSkarbowych_v4-0E.xsd'"/>
	<xsl:param name="schema-walut" select="'http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2021/12/23/eD/KodyWalut/KodyWalut_v1-0E.xsd'"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:call-template name="TytulDokumentu"/>
				</title>
				<xsl:call-template name="StyleWspolne"/>
				<xsl:call-template name="StyleDlaFormularza"/>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="Podmiot">
		<xsl:param name="sekcja"/>
		<xsl:param name="pokazuj-adres" select="true()"/>
		<xsl:param name="wstaw-przed-ident"/>
		<xsl:param name="wstaw-za-ident"/>
		<xsl:param name="wstaw-przed-adres"/>
		<xsl:param name="wstaw-za-adres"/>
		<xsl:variable name="tytul-sekcji">
			<xsl:choose>
				<xsl:when test="@rola='Strona umowy'">DANE STRONY UMOWY</xsl:when>
				<xsl:when test="@rola='NierezydentŚwiadczącyUsługi'">DANE NIEREZYDENTA ŚWIADCZĄCEGO USŁUGI (WYKONUJĄCEGO PRACĘ)</xsl:when>
				<xsl:when test="@rola='SkładającyInformację'">DANE PODMIOTU SKŁADAJĄCEGO INFORMACJĘ</xsl:when>
				<xsl:when test="@rola='Składający informację'">DANE SKŁADAJĄCEGO INFORMACJĘ</xsl:when>
				<xsl:when test="@rola='Spadkodawca, Darczyńca lub inna osoba'">DANE SPADKODAWCY, DARCZYŃCY LUB INNEJ OSOBY (PODMIOTU), PO KTÓREJ LUB OD KTÓREJ ZOSTAŁY NABYTE RZECZY LUB PRAWA MAJĄTKOWE</xsl:when>
				<xsl:when test="@rola='Zainteresowany'">DANE ZAINTERESOWANEGO</xsl:when>
				<xsl:when test="@rola='Grupa Kapitałowa'">DANE PODATKOWEJ GRUPY KAPITAŁOWEJ</xsl:when>
				<xsl:when test="@rola='Obowiązany'">DANE OBOWIĄZANEGO</xsl:when>
				<xsl:when test="@rola='Podatnik'">DANE PODATNIKA</xsl:when>
				<xsl:when test="@rola='Platnik'">DANE PŁATNIKA </xsl:when>
				<xsl:when test="@rola='Płatnik'">DANE PŁATNIKA</xsl:when>
				<xsl:when test="@rola='Małżonek'">DANE MAŁŻONKA</xsl:when>
				<xsl:when test="@rola='Składający'">DANE SKŁADAJĄCEGO</xsl:when>
				<xsl:when test="@rola='Płatnik/Podmiot (Wypłacający Należność)'">DANE PŁATNIKA/PODMIOTU (WYPŁACAJĄCEGO NALEŻNOŚĆ)</xsl:when>
				<xsl:when test="@rola='Odbiorca Należności'">DANE PODATNIKA (ODBIORCY NALEŻNOŚCI)</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@rola"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="sekcja">
			<h2 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/> <xsl:copy-of select="$tytul-sekcji"/>
			</h2>
			<xsl:apply-templates select="*[local-name()='OsobaFizyczna']           | *[local-name()='OsobaNiefizyczna']           | *[local-name()='OsobaFizZagr']           | *[local-name()='OsobaNieFizZagr']">
				<xsl:with-param name="sekcja"/>
				<xsl:with-param name="wstaw-przed-ident" select="$wstaw-przed-ident"/>
				<xsl:with-param name="wstaw-za-ident" select="$wstaw-za-ident"/>
			</xsl:apply-templates>
			<xsl:if test="$pokazuj-adres">
				<xsl:apply-templates select="*[local-name()='AdresZamieszkania']            | *[local-name()='AdresSiedziby']            | *[local-name()='AdresZamieszkaniaSiedziby']           | *[local-name()='AdresPobytuNaTerytoriumRP'] ">
					<xsl:with-param name="sekcja"/>
					<xsl:with-param name="wstaw-przed-adres" select="$wstaw-przed-adres"/>
					<xsl:with-param name="wstaw-za-adres" select="$wstaw-za-adres"/>
				</xsl:apply-templates>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template match="*[local-name()='OsobaFizyczna']">
		<xsl:param name="sekcja"/>
		<xsl:param name="wstaw-przed-ident"/>
		<xsl:param name="wstaw-za-ident"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:if test="$sekcja">
				<xsl:value-of select="$sekcja"/> 
			</xsl:if>
			<xsl:text>Dane Identyfikacyjne</xsl:text>
		</h3>
		<xsl:copy-of select="$wstaw-przed-ident"/>
		<table class="normalna">
			<tr>
				<xsl:if test="*[local-name()='NIP' ]">
					<td class="wypelniane">
						<div class="opisrubryki"> Identyfikator podatkowy NIP</div>
						<xsl:apply-templates select="*[local-name() = 'NIP']"/>
					</td>
				</xsl:if>
				<xsl:if test="*[local-name()='PESEL' ]">
					<td class="wypelniane">
						<div class="opisrubryki">Identyfikator podatkowy numer PESEL</div>
						<xsl:apply-templates select="*[local-name() = 'PESEL']"/>
					</td>
				</xsl:if>
			</tr>
		</table>
		<table class="normalna">
			<tr>
				<td class="wypelniane" style="width:40%">
					<div class="opisrubryki">Nazwisko</div>
					<xsl:apply-templates select="*[local-name()='Nazwisko']"/>
				</td>
				<td class="wypelniane" style="width:40%">
					<div class="opisrubryki">Pierwsze imię</div>
					<xsl:apply-templates select="*[local-name()='ImiePierwsze']"/>
				</td>
				<td class="wypelniane" style="width:20%">
					<div class="opisrubryki">Data urodzenia</div>
					<xsl:apply-templates select="*[local-name()='DataUrodzenia']"/>
				</td>
			</tr>
		</table>
		<xsl:if test="*[local-name()='ImieOjca' or local-name()='ImieMatki' or local-name()='Obywatelstwo']">
			<table class="normalna">
				<tr>
					<xsl:if test="*[local-name()='ImieOjca' or local-name()='ImieMatki']">
						<td class="wypelniane">
							<div class="opisrubryki">Imię ojca</div>
							<xsl:apply-templates select="*[local-name() = 'ImieOjca']"/>
						</td>
						<td class="wypelniane">
							<div class="opisrubryki">Imię matki</div>
							<xsl:apply-templates select="*[local-name() = 'ImieMatki']"/>
						</td>
					</xsl:if>
					<xsl:if test="*[local-name()='Obywatelstwo']">
						<td class="wypelniane">
							<div class="opisrubryki">Obywatelstwo</div>
							<xsl:apply-templates select="*[local-name() = 'Obywatelstwo']"/>
						</td>
					</xsl:if>
				</tr>
			</table>
			<xsl:copy-of select="$wstaw-za-ident"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*[local-name()='OsobaNiefizyczna']">
		<xsl:param name="sekcja"/>
		<xsl:param name="wstaw-przed-ident"/>
		<xsl:param name="wstaw-za-ident"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:if test="$sekcja">
				<xsl:value-of select="$sekcja"/> 
			</xsl:if>
			<xsl:text>Dane Identyfikacyjne</xsl:text>
		</h3>
		<xsl:copy-of select="$wstaw-przed-ident"/>
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Identyfikator podatkowy NIP</div>
					<xsl:apply-templates select="*[local-name()='NIP']"/>
				</td>
				<xsl:if test="*[local-name()='REGON']">
					<td class="wypelniane">
						<div class="opisrubryki">REGON</div>
						<xsl:apply-templates select="*[local-name()='REGON']"/>
					</td>
				</xsl:if>
			</tr>
			<tr>
				<td colspan="2" class="wypelniane">
					<div class="opisrubryki">Nazwa pełna</div>
					<xsl:apply-templates select="*[local-name()='PelnaNazwa']"/>
				</td>
			</tr>
			<xsl:if test="*[local-name()='SkroconaNazwa']">
				<tr>
					<td colspan="2" class="wypelniane">
						<div class="opisrubryki">Nazwa skrócona</div>
						<xsl:apply-templates select="*[local-name()='SkroconaNazwa']"/>
					</td>
				</tr>
			</xsl:if>
		</table>
		<xsl:copy-of select="$wstaw-za-ident"/>
	</xsl:template>
	<xsl:template match="*[local-name()='OsobaFizZagr']">
		<xsl:param name="sekcja"/>
		<xsl:param name="wstaw-przed-ident"/>
		<xsl:param name="wstaw-za-ident"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:if test="$sekcja">
				<xsl:value-of select="$sekcja"/> 
			</xsl:if>
			<xsl:text>Dane Identyfikacyjne</xsl:text>
		</h3>
		<xsl:copy-of select="$wstaw-przed-ident"/>
		<table class="normalna">
			<tr>
				<td class="wypelniane" style="width:50%">
					<div class="opisrubryki">Nazwisko</div>
					<xsl:apply-templates select="*[local-name()='Nazwisko']"/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Pierwsze imię</div>
					<xsl:apply-templates select="*[local-name()='ImiePierwsze']"/>
				</td>
			</tr>
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Imię ojca</div>
					<xsl:apply-templates select="*[local-name()='ImieOjca'] "/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Imię matki</div>
					<xsl:apply-templates select="*[local-name()='ImieMatki']"/>
				</td>
			</tr>
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki" style="width:50%">Data urodzenia</div>
					<xsl:apply-templates select="*[local-name()='DataUrodzenia']"/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Kraj urodzenia</div>
					<xsl:apply-templates select="*[local-name()='KodKrajuUrodzenia']"/>
				</td>
			</tr>
			<tr>
				<td class="wypelniane" colspan="2">
					<div class="opisrubryki">Miejsce urodzenia</div>
					<xsl:apply-templates select="*[local-name()='MiejsceUrodzenia']"/>
				</td>
			</tr>
			<tr>
				<td class="wypelniane" style="width:50%">
					<div class="opisrubryki">Numer Identyfikacji Podatkowej</div>
					<xsl:apply-templates select="*[local-name()='NrIdTIN']"/>
				</td>
				<td class="wypelniane" style="width:50%">
					<div class="opisrubryki">Kraj wydania Numeru Identyfikacji Podatkowej</div>
					<xsl:apply-templates select="*[local-name()='KodkrajuWydaniaNrId']"/>
				</td>
			</tr>
			<tr>
				<td class="wypelniane" colspan="2">
					<div class="opisrubryki">Numer paszportu lub innego dokumentu stwierdzającego tożsamość</div>
					<xsl:apply-templates select="*[local-name()='NrDokumentuTozsamosci']"/>
				</td>
			</tr>
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Rodzaj dokumentu</div>
					<xsl:choose>
						<xsl:when test="RodzajDokumentuTozsamosci='2'">2. dokument ubezpieczeniowy</xsl:when>
						<xsl:when test="RodzajDokumentuTozsamosci='3'">3. paszport</xsl:when>
						<xsl:when test="RodzajDokumentuTozsamosci='4'">4. urzędowy dokument stwierdzający tożsamość</xsl:when>
						<xsl:when test="RodzajDokumentuTozsamosci='8'">8. inny rodzaj identyfikacji podatkowej</xsl:when>
						<xsl:otherwise>9. inny dokument potwierdzający tożsamość</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Kraj wydania dokumentu wymienionego w poz.31</div>
					<xsl:apply-templates select="*[local-name()='KodKrajuWydaniaDokumentuTozsamosci']"/>
				</td>
			</tr>
		</table>
		<xsl:copy-of select="$wstaw-za-ident"/>
	</xsl:template>
	<xsl:template match="*[local-name()='OsobaNieFizZagr']">
		<xsl:param name="sekcja"/>
		<xsl:param name="wstaw-przed-ident"/>
		<xsl:param name="wstaw-za-ident"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:if test="$sekcja">
				<xsl:value-of select="$sekcja"/> 
			</xsl:if>
			<xsl:text>Dane Identyfikacyjne</xsl:text>
		</h3>
		<xsl:copy-of select="$wstaw-przed-ident"/>
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Identyfikator podatkowy NIP</div>
					<xsl:apply-templates select="*[local-name()='NIP']"/>
				</td>
			</tr>
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Nazwa pełna</div>
					<xsl:apply-templates select="*[local-name()='PelnaNazwa']"/>
				</td>
			</tr>
		</table>
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Nazwa skrócona</div>
					<xsl:apply-templates select="*[local-name()='SkroconaNazwa']"/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Data rozpoczęcia działalności</div>
					<xsl:apply-templates select="*[local-name()='DataRozpoczeciaDzialalnosci']"/>
				</td>
			</tr>
		</table>
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Rodzaj identyfikacji</div>
					<xsl:apply-templates select="*[local-name()='RodzajIdentyfikacji']"/>
				</td>
			</tr>
		</table>
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Numer identyfikacyjny podatnika</div>
					<xsl:apply-templates select="*[local-name()='NumerIdentyfikacyjnyPodatnika']"/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Kod kraju wydania</div>
					<xsl:apply-templates select="*[local-name()='KodKrajuWydania']"/>
				</td>
			</tr>
		</table>
		<xsl:copy-of select="$wstaw-za-ident"/>
	</xsl:template>
	<xsl:template match="*[local-name()='AdresZamieszkania']">
		<xsl:param name="sekcja"/>
		<xsl:param name="wstaw-przed-adres"/>
		<xsl:param name="wstaw-za-adres"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:if test="$sekcja">
				<xsl:value-of select="$sekcja"/> 
			</xsl:if>
			<xsl:text>Adres Zamieszkania</xsl:text>
		</h3>
		<xsl:copy-of select="$wstaw-przed-adres"/>
		<xsl:choose>
			<xsl:when test="*[local-name()='AdresPol'] | *[local-name()='AdresZagr']">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="AdresTabela"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:copy-of select="$wstaw-za-adres"/>
	</xsl:template>
	<xsl:template match="*[local-name()='AdresSiedziby']">
		<xsl:param name="sekcja"/>
		<xsl:param name="wstaw-przed-adres"/>
		<xsl:param name="wstaw-za-adres"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:if test="$sekcja">
				<xsl:value-of select="$sekcja"/> 
			</xsl:if>
			<xsl:text>Adres Siedziby</xsl:text>
		</h3>
		<xsl:copy-of select="$wstaw-przed-adres"/>
		<xsl:choose>
			<xsl:when test="*[local-name()='AdresPol'] | *[local-name()='AdresZagr']">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="AdresTabela"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:copy-of select="$wstaw-za-adres"/>
	</xsl:template>
	<xsl:template match="*[local-name()='AdresZamieszkaniaSiedziby']">
		<xsl:param name="sekcja"/>
		<xsl:param name="wstaw-przed-adres"/>
		<xsl:param name="wstaw-za-adres"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:if test="$sekcja">
				<xsl:value-of select="$sekcja"/> 
			</xsl:if>
			<xsl:text>Adres Siedziby / Zamieszkania</xsl:text>
		</h3>
		<xsl:copy-of select="$wstaw-przed-adres"/>
		<xsl:choose>
			<xsl:when test="*[local-name()='AdresPol'] | *[local-name()='AdresZagr']">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="AdresTabela"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:copy-of select="$wstaw-za-adres"/>
	</xsl:template>
	<xsl:template match="*[local-name()='AdresPobytuNaTerytoriumRP']">
		<xsl:param name="sekcja"/>
		<xsl:param name="wstaw-przed-adres"/>
		<xsl:param name="wstaw-za-adres"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:if test="$sekcja">
				<xsl:value-of select="$sekcja"/> 
			</xsl:if>
			<xsl:text>Adres pobytu na terytorium RP</xsl:text>
		</h3>
		<xsl:copy-of select="$wstaw-przed-adres"/>
		<xsl:choose>
			<xsl:when test="*[local-name()='AdresPol'] | *[local-name()='AdresZagr']">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="AdresTabela"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:copy-of select="$wstaw-za-adres"/>
	</xsl:template>
	<xsl:template match="*[local-name()='AdresPol'] | *[local-name()='AdresZagr']" name="AdresTabela">
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Kraj</div>
					<xsl:apply-templates select="*[local-name()='KodKraju']"/>
				</td>
				<td class="wypelniane" style="width:40%">
					<div class="opisrubryki">Województwo</div>
					<xsl:apply-templates select="*[local-name()='Wojewodztwo']"/>
				</td>
				<td class="wypelniane" style="width:40%">
					<div class="opisrubryki">Powiat</div>
					<xsl:apply-templates select="*[local-name()='Powiat']"/>
				</td>
			</tr>
		</table>
		<table class="normalna">
			<tr>
				<td class="wypelniane" style="width:35%">
					<div class="opisrubryki">Gmina</div>
					<xsl:apply-templates select="*[local-name()='Gmina']"/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Ulica</div>
					<xsl:apply-templates select="*[local-name()='Ulica']"/>
				</td>
				<td class="wypelniane" style="width:10%">
					<div class="opisrubryki">Numer domu</div>
					<xsl:apply-templates select="*[local-name()='NrDomu']"/>
				</td>
				<td class="wypelniane" style="width:10%">
					<div class="opisrubryki">Numer lokalu</div>
					<xsl:apply-templates select="*[local-name()='NrLokalu']"/>
				</td>
			</tr>
		</table>
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Miejscowość</div>
					<xsl:apply-templates select="*[local-name()='Miejscowosc']"/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Kod pocztowy</div>
					<xsl:apply-templates select="*[local-name()='KodPocztowy']"/>
				</td>
				<xsl:if test="*[local-name()='Poczta']">
					<td class="wypelniane">
						<div class="opisrubryki">Poczta</div>
						<xsl:apply-templates select="*[local-name()='Poczta']"/>
					</td>
				</xsl:if>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="*[local-name()='KodKraju'] | *[local-name()='KodkrajuWydania']        |*[local-name()='KodkrajuWydaniaNrId']        |*[local-name()='KodKrajuUrodzenia'] | *[local-name()='P_D3']        |*[local-name()='KodKrajuWydaniaDokumentuTozsamosci']" name="PokazKodKraju">
		<xsl:apply-templates/> 
		<xsl:if test="$nazwy-dla-kodow">
			<span class="nazwa-dla-kodu">
				<xsl:text>(</xsl:text>
				<xsl:call-template name="ZnajdzWEnumeracji">
					<xsl:with-param name="schema" select="$schema-krajow"/>
					<xsl:with-param name="typ" select="'TKodKraju'"/>
					<xsl:with-param name="kod" select="text()"/>
				</xsl:call-template>
				<xsl:text>)</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*[local-name()='KodWaluty']" name="PokazKodWaluty">
		<xsl:apply-templates/> 
		<xsl:if test="$nazwy-dla-kodow">
			<span class="nazwa-dla-kodu">
				<xsl:text>(</xsl:text>
				<xsl:call-template name="ZnajdzWEnumeracji">
					<xsl:with-param name="schema" select="$schema-walut"/>
					<xsl:with-param name="typ" select="'TKodWaluty'"/>
					<xsl:with-param name="kod" select="text()"/>
				</xsl:call-template>
				<xsl:text>)</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NaglowekTechniczny">
		<xsl:param name="uzycie"/>
		<!-- deklaracja | zalacznik -->
		<xsl:param name="naglowek"/>
		<xsl:param name="alternatywny-naglowek" select="$naglowek"/>
		<xsl:variable name="kod" select="$naglowek/*[local-name()='KodFormularza']"/>
		<xsl:variable name="kod2" select="$alternatywny-naglowek/*[local-name()='KodFormularza']"/>
		<xsl:variable name="wariant" select="$naglowek/*[local-name()='WariantFormularza']"/>
		<div class="naglowek">
			<table>
				<tr>
					<td colspan="2">
						<span class="kod-formularza">
							<xsl:apply-templates select="$kod"/>
						</span>
						<xsl:text> </xsl:text>
						<span class="wariant">(<xsl:apply-templates select="$wariant"/>)</span>
					</td>
				</tr>
				<tr>
					<td class="etykieta">Kod systemowy</td>
					<td class="wartosc">
						<xsl:value-of select="$kod/@kodSystemowy"/>
					</td>
				</tr>
				<xsl:call-template name="AtrybutNaglowka">
					<xsl:with-param name="etykieta">Kod podatku</xsl:with-param>
					<xsl:with-param name="pierwszy" select="$kod/@kodPodatku"/>
					<xsl:with-param name="drugi" select="$kod2/@kodPodatku"/>
				</xsl:call-template>
			</table>
		</div>
	</xsl:template>
	<xsl:template name="AtrybutNaglowka">
		<xsl:param name="etykieta"/>
		<xsl:param name="pierwszy"/>
		<xsl:param name="drugi"/>
		<xsl:variable name="wartosc">
			<xsl:choose>
				<xsl:when test="$pierwszy">
					<xsl:value-of select="$pierwszy"/>
				</xsl:when>
				<xsl:when test="$drugi">
					<xsl:value-of select="$drugi"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($wartosc) &gt; 0">
			<tr>
				<td class="etykieta">
					<xsl:copy-of select="$etykieta"/>
				</td>
				<td class="wartosc">
					<xsl:value-of select="$wartosc"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NaglowekTytulowy">
		<xsl:param name="naglowek"/>
		<xsl:param name="nazwa"/>
		<xsl:param name="objasnienie"/>
		<xsl:param name="podstawy-prawne"/>
		<xsl:param name="uzycie"/>
		<xsl:param name="nad-data"/>
		<xsl:param name="przed-data"/>
		<xsl:param name="po-dacie"/>
		<!-- deklaracja | zalacznik -->
		<div>
			<xsl:choose>
				<xsl:when test="$uzycie = 'deklaracja'">
					<xsl:attribute name="class">tlo-formularza</xsl:attribute>
				</xsl:when>
				<xsl:when test="$uzycie = 'zalacznik'">
					<xsl:attribute name="class">tlo-zalacznika</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="$nazwa">
				<h1 class="nazwa">
					<xsl:copy-of select="$nazwa"/>
				</h1>
			</xsl:if>
			<xsl:copy-of select="$nad-data"/>
			<xsl:if test="$naglowek">
				<div class="okres">
					<xsl:if test="$przed-data or $po-dacie">
						<span class="obok-daty">
							<xsl:copy-of select="$przed-data"/>
						</span>
					</xsl:if>
					<xsl:apply-templates select="$naglowek/*[local-name()='Miesiac'] | $naglowek/*[local-name()='Kwartal']"/>
					<xsl:apply-templates select="$naglowek/*[local-name()='Rok']"/>
					<xsl:apply-templates select="$naglowek/*[local-name()='OkresOd']"/>
					<xsl:apply-templates select="$naglowek/*[local-name()='OkresDo']"/>
					<xsl:apply-templates select="$naglowek/*[local-name()='Data']"/>
					<xsl:if test="$przed-data or $po-dacie">
						<span class="obok-daty">
							<xsl:copy-of select="$po-dacie"/>
						</span>
					</xsl:if>
				</div>
			</xsl:if>
			<xsl:if test="$objasnienie">
				<div class="objasnienie">
					<xsl:copy-of select="$objasnienie"/>
				</div>
			</xsl:if>
		</div>
		<xsl:if test="$podstawy-prawne">
			<div class="prawne">
				<xsl:copy-of select="$podstawy-prawne"/>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*[local-name()='Naglowek']/*[local-name()='Miesiac']">
		<span class="data">
			<span class="opisrubryki">
				<xsl:call-template name="WezNumerPozycji"/>
				<xsl:text>Miesiąc  </xsl:text>
			</span>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="*[local-name()='Naglowek']/*[local-name()='Kwartal']">
		<span class="data">
			<span class="opisrubryki">
				<xsl:call-template name="WezNumerPozycji"/>
				<xsl:text>Kwartał  </xsl:text>
			</span>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="*[local-name()='Naglowek']/*[local-name()='Rok']">
		<span class="data">
			<span class="opisrubryki">
				<xsl:call-template name="WezNumerPozycji"/>
				<xsl:text>Rok  </xsl:text>
			</span>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="*[local-name()='Naglowek']/*[local-name()='OkresOd']">
		za okres <span class="data">
			<span class="opisrubryki">
				<xsl:call-template name="WezNumerPozycji"/>
			</span>
			<xsl:text>od </xsl:text>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="*[local-name()='Naglowek']/*[local-name()='OkresDo']">
		 <span class="data">
			<span class="opisrubryki">
				<xsl:call-template name="WezNumerPozycji"/>
			</span>
			<xsl:text>do </xsl:text>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="*[local-name()='Naglowek']/*[local-name()='Data']">
		<span class="data">
			<span class="opisrubryki">
				<xsl:call-template name="WezNumerPozycji"/>
				<xsl:text>Data  </xsl:text>
			</span>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template name="WezNumerPozycji">
		<xsl:if test="a">
			<xsl:value-of select="substring(@poz, 3)"/>
			<xsl:text>.</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="MiejsceICel">
		<xsl:param name="sekcja"/>
		<h2 class="tytul-sekcja-blok">
			<xsl:value-of select="$sekcja"/> MIEJSCE I CEL SKŁADANIA</h2>
		<table class="normalna">
			<tr>
				<td class="niewypelnianeopisy" style="width:33%">Kod i nazwa urzędu skarbowego, do którego adresowany jest dokument</td>
				<td class="wypelniane" style="width:auto">
					<xsl:apply-templates select="*[local-name()='Naglowek']/*[local-name()='KodUrzedu']"/>
				</td>
			</tr>
			<tr>
				<td class="niewypelnianeopisy">Cel złożenia formularza</td>
				<td class="wypelniane">
					<xsl:choose>
						<xsl:when test="*[local-name()='Naglowek']/*[local-name()='CelZlozenia'] =1">
							<input type="checkbox" checked="checked" disabled="disabled"/>1. złożenie
						</xsl:when>
						<xsl:when test="*[local-name()='Naglowek']/*[local-name()='CelZlozenia'] =2">
							<input type="checkbox" checked="checked" disabled="disabled"/>2. korekta
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="*[local-name()='Naglowek']/*[local-name()='KodUrzedu'] | *[local-name()='Naglowek']/*[local-name()='PoprzedniNaczelnikUS'] ">
		<xsl:apply-templates/> 
		<xsl:if test="$nazwy-dla-kodow">
			<span class="nazwa-dla-kodu">
				<xsl:call-template name="ZnajdzWEnumeracji">
					<xsl:with-param name="schema" select="$schema-urzedow"/>
					<xsl:with-param name="typ" select="'TKodUS'"/>
					<xsl:with-param name="kod" select="text()"/>
				</xsl:call-template>
			</span>
		</xsl:if>
	</xsl:template>
	<xsl:template name="KrajUzyskaniaDochodu">
		<xsl:apply-templates/> 
		<xsl:if test="$nazwy-dla-kodow">
			<span class="nazwa-dla-kodu">
				<xsl:text>(</xsl:text>
				<xsl:call-template name="ZnajdzWEnumeracji">
					<xsl:with-param name="schema" select="$schema-krajow"/>
					<xsl:with-param name="typ" select="'TKodKraju'"/>
					<xsl:with-param name="kod" select="text()"/>
				</xsl:call-template>
				<xsl:text>)</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PouczeniaKoncowe">
		<xsl:param name="sekcja"/>
		<xsl:param name="etykieta"/>
		<xsl:if test="*[local-name()='Pouczenie' or local-name()='Pouczenie1' or local-name()='Pouczenie2']">
			<h2 class="tekst">*) Pouczenie</h2>
			<xsl:for-each select="*[local-name()='Pouczenie' or local-name()='Pouczenie1' or local-name()='Pouczenie2']">
				<div class="pouczenie">
					<xsl:apply-templates/>
				</div>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="*[local-name()='Oswiadczenie']">
			<h2 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/> <xsl:copy-of select="$etykieta"/>
			</h2>
			<table class="pouczenia">
				<tr>
					<td>
						<xsl:apply-templates select="*[local-name()='Oswiadczenie']"/>
					</td>
				</tr>
			</table>
			<div class="lamstrone"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PozycjaSzczegolowa">
		<xsl:param name="element"/>
		<xsl:param name="prefiks" select="'P_'"/>
		<xsl:param name="etykieta"/>
		<xsl:variable name="nazwa">
			<xsl:choose>
				<xsl:when test="@poz">
					<xsl:value-of select="@poz"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="local-name($element)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="numer">
			<xsl:choose>
				<xsl:when test="starts-with($nazwa, $prefiks)">
					<xsl:value-of select="substring-after($nazwa, $prefiks)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="opisrubryki">
			<xsl:value-of select="$numer"/>
			<xsl:text>.</xsl:text>
			<xsl:if test="$etykieta"> <xsl:copy-of select="$etykieta"/>
			</xsl:if>
		</div>
		<xsl:apply-templates select="$element"/>
	</xsl:template>
	<xsl:template name="PozycjaSzczegolowa2">
		<xsl:param name="prefiks" select="'P_'"/>
		<xsl:param name="numer"/>
		<xsl:param name="etykieta"/>
		<xsl:variable name="nazwa" select="concat($prefiks, $numer)"/>
		<div class="opisrubryki">
			<xsl:value-of select="$numer"/>
			<xsl:text>.</xsl:text>
			<xsl:if test="$etykieta"> <xsl:copy-of select="$etykieta"/>
			</xsl:if>
		</div>
		<xsl:apply-templates select="*[local-name() = $nazwa]"/>
	</xsl:template>
	<xsl:template name="TakNie">
		<xsl:param name="element"/>
		<xsl:choose>
			<xsl:when test="$element">tak</xsl:when>
			<xsl:otherwise>nie</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="TakNie12">
		<xsl:choose>
			<xsl:when test=".='1'">
				<input type="checkbox" checked="checked" disabled="disabled"/>1. tak
			</xsl:when>
			<xsl:when test=".='2'">
				<input type="checkbox" checked="checked" disabled="disabled"/>2. nie
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ZnajdzWEnumeracji">
		<xsl:param name="schema"/>
		<xsl:param name="typ"/>
		<xsl:param name="kod"/>
		<xsl:variable name="wschema" select="document($schema)"/>
		<xsl:value-of select="$wschema//xs:simpleType[@name=$typ]//    xs:enumeration[@value = $kod]//xs:documentation"/>
	</xsl:template>
	<xsl:template name="StyleWspolne">
		<style type="text/css">
body {
	background-color: #FFFFFF;
	color: #000000;
	font-family: 'Arial', sans-serif;
	font-size: 11pt;
	margin: 0;
	padding: 1px 5%;
}

div.body {
	width: 100%;
	min-width: 480px;
	margin-left: auto;
	margin-right: auto;
}

div.deklaracja, div.zalacznik {
	margin: 2em 0;
}

.tlo-zalacznika {
	background-color: #FFFFDD;
}

table {
	border-collapse: collapse;
}

.normalna, .tytul-sekcja-blok {
	width: 100%;
}

.naglowek {
	background-color: #CCDDFF;
}

.kod-formularza {
	font-size: 2em;
	font-weight: bold;
}

.naglowek .wartosc {
	font-weight: bold;
}

.tytul {
	font-size: 2em;
	font-weight: bold;
	text-align: center;
}

.tytulformularza {
	font-size: xx-large;
	font-weight: bold;
	text-align: center;
}

.okres {
	display: block;
	margin: 1em;
	font-size: 1.2em;
	text-align: center;
	vertical-align: top;
	clear: both;
}

.data {
	border: 1px solid black;
	padding: 2px 1.5em;
	background-color: white;
	font-weight: bold;
	margin: 0 2em;
}

.obok-daty {
	text-align: right;
	display: inline-block;
	width: 45%;
}

.objasnienie {
	border: 2px solid black;
	padding: 0.25em 0.5em;
	font-size: 0.8em;
}

.zalacznik-objasnienie {
	background-color: #DDDDDD;
	border: 2px solid black;
	font-size: 0.8em;
	width:99.5%;
}

.prawne {
	background-color: #DDDDDD;
	border: 2px solid black;
	font-size: 0.8em;
}

.prawne .etykieta {
	min-width: 9em;
}

.wypelniane {
	background-color: white;
}

.niewypelniane, .ukryte {
	background-color: #DDDDDD;
}

.pouczenia td {
	background-color: white;
	border: 2px solid black;
}

.tytul-sekcja-blok {
	background-color: #DDDDFF;
	border: 2px solid black;
	text-transform: uppercase;
	width: 99.5%;
}


h1 {
	font-size: 1.4em;
	font-weight: bold;
	text-align: center;
	text-transform: uppercase;
}

h2 {
	text-align: left;
	font-size: 1.2em;
	font-weight: bold;
}

h3 {
	text-align: left;
	font-size: 1.2em;
	font-weight: normal;
}

h4 {
	text-align: left;
	font-size: 1em;
	font-weight: normal;
}

h1, h2, h3, h4 {
	font-family: 'Arial', sans-serif;
	margin: 0;
	padding: 1px;
}

.wypelniane {
	border: 1px solid black;
	font-size: 1.2em;
	padding: 1px;
	vertical-align: top;
	text-align: left;
}


.puste {
	background-color: #DDDDDD;
	border: 1px solid black;
	font-size: 0.8em;
	padding: 1px;
	height: 2em;
	vertical-align: top;
}

.puste2 {
	background-color: #DDDDDD;
	border: 1px solid black;
	 font-size: 1.2em;
	padding: 1px;
	height: 2em;
	text-align: center;
}

.niewypelnianeopisy {
	background-color: #DDDDDD;
	border: 1px solid black;
	font-size: 0.8em;
	padding: 1px;
	height: 2em;
	vertical-align: top;
	text-align: left;
}

.center {
	background-color: #DDDDDD;
	border: 1px solid black;
	font-size: 0.8em;
	padding: 1px;
	height: 2em;
	vertical-align: top;
	text-align: center;
}

.niewypelniane, .pouczenia td, .taknie {
	border: 1px solid black;
	font-size: 0.8em;
	font-weight: bold;
	padding: 1px;
	height: 2em;
	vertical-align: top;
	text-align: center;
}

.kwota {
	text-align: right;
	padding-right: 0.2em;
}

.opisrubryki {
	font-size: 0.5em;
	margin-bottom: 0.2em;
	text-align: left;
	font-weight: bold;
	text-transform: none;
}

.opis-tekstowy{
	font-size: 0.7em;
	margin-bottom: 0.2em;
	font-weight: bold;
	text-transform: none;
}

.czcionka td, .czcionka th {
	font-size: 0.9em;
	height: 1em;
}

.nazwa-dla-kodu {
	font-size: 0.9em;
}

table.normalna, table.pouczenia, table.sposob-opodatkowania {
	width: 100%;
	margin: 0;
	border: 1px solid black;
}

h2.tekst {
	text-align: center;
	margin: 0.5em auto;
}

.pouczenie {
	padding: 0.5em 2em;
	text-align: center;
}

p {
	padding: 0;
	margin: 0.2em 0;
}

.objasnienie ol {
	list-style-type: decimal;
}

.objasnienie ol ul {
	list-style-type: disc;
}

.taknie {
	text-transform: uppercase;
	text-align: center;
}

.normalna-tekstowa {
	width: 100%;
	border: 0px
}

 .tekst {
	text-align: center;
}

.wartosc {
	vertical-align: top;
}

.miesiac {
	border: 1px solid black;
	font-size: 0.8em;
	font-weight: bold;
	padding: 1px;
	height: 2em;
	vertical-align: middle;
	text-align: center;
	background-color: #DDDDDD;
}

.podtytul {
	font-size: medium;
}

.tytulzalacznika {
	font-size: x-large;
	font-weight: bold;
	text-align: center;
}

.opis {
	font-size: 1em;
	padding: 4px;
}

.opis-tabela {
	font-size: 1em;
	padding: 4px;
	border: 0;
}

.dodatkowe {
	background-color: white;
	border: 0;
}

.wypunktowane {
	font-size: 1em;
	padding: 1px;
	vertical-align: top;
}

.tlo-formularza, .tlo-zalacznika {
	padding-bottom: 1px;
}

@media print {
	.lamstrone {
		page-break-before: always;
	}

	.sekcja {
		page-break-inside: avoid;
	}
}</style>
	</xsl:template>
<xsl:output method="html" encoding="UTF-8" indent="yes" version="4.01" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>
	<xsl:template name="TytulDokumentu">
		  e-FAKTURA KSeF
   	</xsl:template>
	<xsl:template name="StyleDlaFormularza">
		<style type="text/css">

    .tlo-formularza { background-color:#D3D3D3; }
    table.wrapping, .break-word {
    white-space: normal !important;
    word-wrap: break-word;
	}

	table {
    width:100%;
	}

	.word-break {
    width:100%;
    word-break: break-all;
	}

	.tlo-zalacznika {
	background-color: #D3D3D3;
	}

    .lewa {	border: 1px solid black; font-size: 1.2em; padding: 1px; vertical-align: top; text-align: left;}
    .srodek { border: 1px solid black; font-size: 1.2em; padding: 1px; vertical-align: top; text-align: center;}
    .prawa { border: 1px solid black; font-size: 1.2em; padding: 1px; vertical-align: top; text-align: right;}
   </style>
	</xsl:template>
	<xsl:template match="tns:Faktura">
		<div class="deklaracja">
			<div class="naglowek">
				<table>
					<tr>
						<td colspan="2">
							<span class="kod-formularza">
								<xsl:value-of select="tns:Naglowek/tns:KodFormularza"/>
							</span>
							<xsl:text> </xsl:text>
							<span class="wariant">(<xsl:value-of select="tns:Naglowek/tns:WariantFormularza"/>)</span>
						</td>
					</tr>
					<tr>
						<td class="etykieta">Kod systemowy <b>
								<xsl:value-of select="tns:Naglowek/tns:KodFormularza/@kodSystemowy"/>
							</b>
						</td>
					</tr>
				</table>
			</div>
			<xsl:call-template name="NaglowekTytulowyKSeF"/>
			<xsl:call-template name="NaglowekTytulowy">
				<xsl:with-param name="uzycie" select="'deklaracja'"/>
				<xsl:with-param name="nazwa">
					<xsl:choose>
						<xsl:when test="tns:Fa/tns:RodzajFaktury = 'VAT'">
							<xsl:text>Faktura podstawowa</xsl:text>
						</xsl:when>
						<xsl:when test="tns:Fa/tns:RodzajFaktury = 'KOR'">
							<xsl:text>Faktura korygująca</xsl:text>
						</xsl:when>
						<xsl:when test="tns:Fa/tns:RodzajFaktury = 'ZAL'">
							<xsl:text>Faktura dokumentująca otrzymanie zapłaty lub jej części przed dokonaniem czynności oraz faktura wystawiona w związku z art. 106f ust. 4 ustawy (faktura zaliczkowa)</xsl:text>
						</xsl:when>
						<xsl:when test="tns:Fa/tns:RodzajFaktury = 'ROZ'">
							<xsl:text>Faktura wystawiona w związku z art. 106f ust. 3 ustawy</xsl:text>
						</xsl:when>
						<xsl:when test="tns:Fa/tns:RodzajFaktury = 'UPR'">
							<xsl:text>Faktura, o której mowa w art. 106e ust. 5 pkt 3 ustawy</xsl:text>
						</xsl:when>
						<xsl:when test="tns:Fa/tns:RodzajFaktury = 'KOR_ZAL'">
							<xsl:text>Faktura korygująca fakturę dokumentującą otrzymanie zapłaty lub jej części przed dokonaniem czynności oraz fakturę wystawioną w związku z art. 106f ust. 4 ustawy (faktura korygująca fakturę zaliczkową)</xsl:text>
						</xsl:when>
						<xsl:when test="tns:Fa/tns:RodzajFaktury = 'KOR_ROZ'">
							<xsl:text>Faktura korygująca fakturę wystawioną w związku z art. 106f ust. 3 ustawy</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="NrFaktury"/>
			<xsl:call-template name="SprzedawcaNabywca"/>
			<xsl:call-template name="InnyPodmiot"/>
			<xsl:call-template name="PodmiotUpowazniony"/>
			<xsl:call-template name="FakturaWiersze"/>
			<xsl:call-template name="PodliczenieVAT"/>
			<xsl:call-template name="Platnosc"/>
			<xsl:call-template name="Adnotacje"/>
			<xsl:call-template name="PrzyczynaKorekty"/>
			<xsl:call-template name="ZaliczkaCzesciowa"/>
			<xsl:call-template name="DodatkowyOpis"/>
			<xsl:call-template name="Rozliczenie"/>
			<xsl:call-template name="WarunkiTransakcji"/>
			<xsl:call-template name="Zamowienie"/>
			<xsl:call-template name="WZ"/>
			<xsl:call-template name="Stopka"/>
			<xsl:call-template name="NaglowekTytulowyZalacznik">
				<xsl:with-param name="uzycie" select="'zalacznik'"/>
				<xsl:with-param name="nazwa">
					<xsl:text>Załącznik do faktury VAT</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="Zalacznik"/>
			<xsl:call-template name="SystemTeleinfor"/>
		</div>
	</xsl:template>
	<xsl:template name="NaglowekTytulowyKSeF">
		<div style="text-align:left">
			<b>Krajowy System <font style="color:red">e</font>-Faktur (KS<font style="color:red">e</font>F)</b>
		</div>
	</xsl:template>
	<xsl:template name="SystemTeleinfor">
		<br/>
		<td class="niewypelnianeopisy">Data i czas wytworzenia faktury: </td>
		<td class="wypelniane">
			<b>
				<xsl:value-of select="tns:Naglowek/tns:DataWytworzeniaFa"/>
			</b>
		</td>
		<br/>
		<xsl:if test="tns:Naglowek/tns:SystemInfo">
			<table class="break-word">
				<tr>
					<td>Nazwa systemu teleinformatycznego, z którego korzysta podatnik:
					<b>
							<xsl:value-of select="tns:Naglowek/tns:SystemInfo"/>
						</b>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NrFaktury">
		<table class="break-word" width="100%">
			<tr>
				<td>
					Kod waluty (ISO 4217):
					<b>
						<xsl:value-of select="tns:Fa/tns:KodWaluty"/>
					</b>
				</td>
			</tr>
			<tr>
				<td>
					Kolejny numer faktury, nadany w ramach jednej lub więcej serii, który w sposób jednoznaczny identyfikuje fakturę:
				<b>
						<xsl:value-of select="tns:Fa/tns:P_2"/>
					</b>
				</td>
			</tr>
			<tr>
				<td>
				Data wystawienia, z zastrzeżeniem art. 106na ust. 1 ustawy:
				<b>
						<xsl:value-of select="tns:Fa/tns:P_1"/>
					</b>
				</td>
			</tr>
			<xsl:if test="tns:Fa/tns:P_1M">
				<tr>
					<td>Miejsce wystawienia faktury:
						<b>
							<xsl:value-of select="tns:Fa/tns:P_1M"/>
						</b>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td>
					<xsl:if test="tns:Fa/tns:P_6">
					Data dokonania lub zakończenia dostawy towarów lub wykonania usługi lub data otrzymania zapłaty, o której mowa w art. 106b ust. 1 pkt 4 ustawy, o ile taka data jest określona i różni się od daty wystawienia faktury. Pole wypełnia się w przypadku, gdy dla wszystkich pozycji faktury data jest wspólna:
					<b>
							<xsl:value-of select="tns:Fa/tns:P_6"/>
						</b>
					</xsl:if>
					<xsl:if test="tns:Fa/tns:OkresFa">
						<xsl:text>Data początkowa okresu, którego dotyczy faktura: </xsl:text>
						<b>
							<xsl:value-of select="tns:Fa/tns:OkresFa/tns:P_6_Od"/>
						</b>
						<br/>
						<xsl:text> Data końcowa okresu, którego dotyczy faktura - data dokonania lub zakończenia dostawy towarów lub wykonania usługi: </xsl:text>
						<b>
							<xsl:value-of select="tns:Fa/tns:OkresFa/tns:P_6_Do"/>
						</b>
					</xsl:if>
				</td>
			</tr>
			<xsl:if test="tns:Fa/tns:FP = '1'">
				<tr>
					<td>Faktura, o której mowa w art. 109 ust. 3d ustawy:
				<input type="checkbox" checked="checked" disabled="disabled"/>
						<b>1. Tak</b>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="tns:Fa/tns:TP = '1'">
				<tr>
					<td>Istniejące powiązania między nabywcą a dokonującym dostawy towarów lub usługodawcą, zgodnie z § 10 ust. 4 pkt 3, z zastrzeżeniem ust. 4b rozporządzenia w sprawie szczegółowego zakresu danych zawartych w deklaracjach podatkowych i w ewidencji w zakresie podatku od towarów i usług:
			<input type="checkbox" checked="checked" disabled="disabled"/>
						<b>1. Tak</b>
					</td>
				</tr>
			</xsl:if>
			<br/>
			<br/>
		</table>
	</xsl:template>
	<xsl:template name="SprzedawcaNabywca">
		<br/>
		<table class="break-word">
			<tr>
				<td style="width:50%">
					<b>SPRZEDAWCA</b>
				</td>
				<td style="width:50%">
					<b>NABYWCA</b>
					<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot1/tns:NrEORI">
						<xsl:text>Numer EORI: </xsl:text>
						<b>
							<xsl:value-of select="tns:Podmiot1/tns:NrEORI"/>
						</b>
					</xsl:if>
				</td>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot2/tns:NrEORI">
						<xsl:text>Numer EORI: </xsl:text>
						<b>
							<xsl:value-of select="tns:Podmiot2/tns:NrEORI"/>
						</b>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:text>NIP: </xsl:text>
					<xsl:value-of select="tns:Podmiot1/tns:PrefiksPodatnika"/>
					<xsl:text> </xsl:text>
					<b>
						<xsl:value-of select="tns:Podmiot1/tns:DaneIdentyfikacyjne/tns:NIP"/>
					</b>
				</td>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:NIP">
						<xsl:text>NIP: </xsl:text>
						<b>
							<xsl:value-of select="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:NIP"/>
						</b>
					</xsl:if>
					<xsl:if test="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:KodUE">
						<xsl:text>Kod (prefiks) nabywcy VAT UE: </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:KodUE"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:NrVatUE"/>
					</xsl:if>
					<xsl:if test="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:NrID">
						<xsl:text>Identyfikator podatkowy inny: </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:KodKraju"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:NrID"/>
					</xsl:if>
					<xsl:if test="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:BrakID = '1'">
						<xsl:text>Podmiot nie posiada identyfikatora podatkowego lub identyfikator nie występuje na fakturze </xsl:text>
						<input type="checkbox" checked="checked" disabled="disabled"/>
						<b>1. Tak</b>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:text>Imię i nazwisko lub nazwa: </xsl:text>
					<xsl:value-of select="tns:Podmiot1/tns:DaneIdentyfikacyjne/tns:Nazwa"/>
				</td>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:Nazwa">
						<xsl:text>Imię i nazwisko lub nazwa: </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:DaneIdentyfikacyjne/tns:Nazwa"/>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<td style="width:50%">
					<b>Adres podatnika</b>
				</td>
				<td style="width:50%">
					<b>Adres nabywcy</b>
				</td>
				<td/>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:text>Kod kraju: </xsl:text>
					<xsl:apply-templates select="tns:Podmiot1/tns:Adres/tns:KodKraju"/>
				</td>
				<td style="width:50%">
					<xsl:text>Kod kraju: </xsl:text>
					<xsl:apply-templates select="tns:Podmiot2/tns:Adres/tns:KodKraju"/>
				</td>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:text>Adres: </xsl:text>
					<xsl:apply-templates select="tns:Podmiot1/tns:Adres/tns:AdresL1"/>
					<xsl:if test="tns:Podmiot1/tns:Adres/tns:AdresL2">
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="tns:Podmiot1/tns:Adres/tns:AdresL2"/>
					</xsl:if>
				</td>
				<td style="width:50%">
					<xsl:text>Adres: </xsl:text>
					<xsl:apply-templates select="tns:Podmiot2/tns:Adres/tns:AdresL1"/>
					<xsl:if test="tns:Podmiot2/tns:Adres/tns:AdresL2">
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="tns:Podmiot2/tns:Adres/tns:AdresL2"/>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot1/tns:Adres/tns:GLN">
						<xsl:text>GLN: </xsl:text>
						<xsl:value-of select="tns:Podmiot1/tns:Adres/tns:GLN"/>
					</xsl:if>
				</td>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot2/tns:Adres/tns:AdresPol/tns:GLN">
						<xsl:text>GLN: </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:Adres/tns:AdresPol/tns:GLN"/>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<xsl:if test="tns:Podmiot1/tns:AdresKoresp/tns:KodKraju|tns:Podmiot1/tns:AdresKoresp/tns:AdresL1">
					<td style="width:50%">
						<b>Adres korespondencyjny podatnika</b>
					</td>
				</xsl:if>
				<xsl:if test="tns:Podmiot2/tns:AdresKoresp/tns:KodKraju|tns:Podmiot2/tns:AdresKoresp/tns:AdresL1">
					<td style="width:50%">
						<b>Adres korespondencyjny nabywcy</b>
					</td>
				</xsl:if>
			</tr>
			<tr>
				<xsl:if test="tns:Podmiot1/tns:AdresKoresp/tns:KodKraju">
					<td style="width:50%">
						<xsl:text>Kod kraju: </xsl:text>
						<xsl:apply-templates select="tns:Podmiot1/tns:AdresKoresp/tns:KodKraju"/>
					</td>
				</xsl:if>
				<xsl:if test="tns:Podmiot2/tns:AdresKoresp/tns:KodKraju">
					<td style="width:50%">
						<xsl:text>Kod kraju: </xsl:text>
						<xsl:apply-templates select="tns:Podmiot2/tns:AdresKoresp/tns:KodKraju"/>
					</td>
				</xsl:if>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot1/tns:AdresKoresp/tns:AdresL1|tns:Podmiot1/tns:AdresKoresp/tns:AdresL2">
						<xsl:text>Adres: </xsl:text>
						<xsl:apply-templates select="tns:Podmiot1/tns:AdresKoresp/tns:AdresL1"/>
						<xsl:if test="tns:Podmiot1/tns:AdresKoresp/tns:AdresL2">
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="tns:Podmiot1/tns:AdresKoresp/tns:AdresL2"/>
						</xsl:if>
					</xsl:if>
				</td>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot2/tns:AdresKoresp/tns:AdresL1|tns:Podmiot2/tns:AdresKoresp/tns:AdresL2">
						<xsl:text>Adres: </xsl:text>
						<xsl:apply-templates select="tns:Podmiot2/tns:AdresKoresp/tns:AdresL1"/>
						<xsl:if test="tns:Podmiot2/tns:AdresKoresp/tns:AdresL2">
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="tns:Podmiot2/tns:AdresKoresp/tns:AdresL2"/>
						</xsl:if>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot1/tns:AdresKoresp/tns:GLN">
						<xsl:text>GLN: </xsl:text>
						<xsl:value-of select="tns:Podmiot1/tns:AdresKoresp/tns:GLN"/>
					</xsl:if>
				</td>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot2/tns:AdresKoresp/tns:GLN">
						<xsl:text>GLN: </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:AdresKoresp/tns:GLN"/>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<xsl:if test="tns:Podmiot1/tns:DaneKontaktowe">
					<td style="width:50%">
						<b>Dane kontaktowe podatnika</b>
					</td>
				</xsl:if>
				<xsl:if test="tns:Podmiot2/tns:DaneKontaktowe">
					<td style="width:50%">
						<b>Dane kontaktowe nabywcy</b>
					</td>
				</xsl:if>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot1/tns:DaneKontaktowe/tns:Email">
						<xsl:text>Adres e-mail: </xsl:text>
						<xsl:for-each select="tns:Podmiot1/tns:DaneKontaktowe/tns:Email">
							<xsl:value-of select="."/>
							<xsl:text>, </xsl:text>
						</xsl:for-each>
					</xsl:if>
				</td>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot2/tns:DaneKontaktowe/tns:Email">
						<xsl:text>Adres e-mail: </xsl:text>
						<xsl:for-each select="tns:Podmiot2/tns:DaneKontaktowe/tns:Email">
							<xsl:value-of select="."/>
							<xsl:text>, </xsl:text>
						</xsl:for-each>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot1/tns:DaneKontaktowe/tns:Telefon">
						<xsl:text>Numer telefonu: </xsl:text>
						<xsl:for-each select="tns:Podmiot1/tns:DaneKontaktowe/tns:Telefon">
							<xsl:value-of select="."/>
							<xsl:text>, </xsl:text>
						</xsl:for-each>
					</xsl:if>
				</td>
				<td style="width:50%">
					<xsl:if test="tns:Podmiot2/tns:DaneKontaktowe/tns:Telefon">
						<xsl:text>Numer telefonu: </xsl:text>
						<xsl:for-each select="tns:Podmiot2/tns:DaneKontaktowe/tns:Telefon">
							<xsl:value-of select="."/>
							<xsl:text>, </xsl:text>
						</xsl:for-each>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<xsl:if test="tns:Podmiot1/tns:StatusInfoPodatnika">
					<td style="width:50%">
						<b>Status podatnika</b>
					</td>
				</xsl:if>
				<xsl:if test="tns:Podmiot2/tns:NrKlienta|tns:Podmiot2/tns:IDNabywcy">
					<td style="width:50%"/>
				</xsl:if>
			</tr>
			<tr>
				<td style="width:50%">
					<xsl:for-each select="tns:Podmiot1">
						<xsl:if test="tns:StatusInfoPodatnika">
							<xsl:choose>
								<xsl:when test="tns:StatusInfoPodatnika = 1">
									<xsl:text>Podatnik znajdujący się w stanie likwidacji</xsl:text>
								</xsl:when>
								<xsl:when test="tns:StatusInfoPodatnika = 2">
									<xsl:text>Podatnik, który jest w trakcie postępowania restrukturyzacyjnego</xsl:text>
								</xsl:when>
								<xsl:when test="tns:StatusInfoPodatnika = 3">
									<xsl:text>Podatnik znajdujący się w stanie upadłości</xsl:text>
								</xsl:when>
								<xsl:when test="tns:StatusInfoPodatnika = 4">
									<xsl:text>Przedsiębiorstwo w spadku</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each>
				</td>
				<xsl:if test="tns:Podmiot2/tns:NrKlienta">
					<td style="width:50%">
						<xsl:text>Numer klienta: </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:NrKlienta"/>
					</td>
				</xsl:if>
			</tr>
			<xsl:if test="tns:Podmiot2/tns:IDNabywcy">
				<tr>
					<td style="width:50%"/>
					<td style="width:50%">
						<xsl:text>ID nabywcy: </xsl:text>
						<xsl:value-of select="tns:Podmiot2/tns:IDNabywcy"/>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td style="width:50%"/>
				<td style="width:50%">
					<xsl:text>Faktura dotyczy jednostki podrzędniej JST: </xsl:text>
					<xsl:choose>
						<xsl:when test="tns:Podmiot2/tns:JST = '1'">
								Tak
							</xsl:when>
						<xsl:when test="tns:Podmiot2/tns:JST = '2'">
								Nie
							</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td style="width:50%"/>
				<td style="width:50%">
					<xsl:text>Faktura dotyczy członka GV: </xsl:text>
					<xsl:choose>
						<xsl:when test="tns:Podmiot2/tns:GV = '1'">
								Tak
							</xsl:when>
						<xsl:when test="tns:Podmiot2/tns:GV = '2'">
								Nie
							</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</table>
		<br/>
	</xsl:template>
	<xsl:template name="InnyPodmiot">
		<xsl:for-each select="tns:Podmiot3">
			<table class="break-word">
				<tr>
					<td style="width:50%"/>
					<td style="width:50%">
						<br/>
						<b>Podmiot trzeci <xsl:number value="position()" format="(1) "/>
						</b>
					</td>
				</tr>
				<tr>
					<td style="width:50%"/>
					<td style="width:50%">
						<xsl:if test="tns:IDNabywcy">
							<xsl:text>Unikalny klucz powiązania danych nabywcy na fakturach korygujących, w przypadku gdy dane nabywcy na fakturze korygującej zmieniły się w stosunku do danych na fakturze korygowanej: </xsl:text>
							<xsl:value-of select="tns:IDNabywcy"/>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td style="width:50%"/>
					<td style="width:50%">
						<xsl:if test="tns:NrEORI">
							<xsl:text>Numer EORI: </xsl:text>
							<xsl:value-of select="tns:NrEORI"/>
						</xsl:if>
					</td>
				</tr>
				<xsl:for-each select="tns:DaneIdentyfikacyjne">
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<xsl:if test="tns:NIP">
								<xsl:text>NIP: </xsl:text>
								<xsl:value-of select="tns:NIP"/>
							</xsl:if>
							<xsl:if test="tns:IDWew">
								<xsl:text>Identyfikator wewnętrzny z NIP: </xsl:text>
								<xsl:value-of select="tns:IDWew"/>
							</xsl:if>
							<xsl:if test="tns:KodUE|tns:NrVatUE">
								<xsl:text>Kod (prefiks) nabywcy VAT UE: </xsl:text>
								<xsl:value-of select="tns:KodUE"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="tns:NrVatUE"/>
							</xsl:if>
							<xsl:if test="tns:NrID">
								<xsl:text>Identyfikator podatkowy inny: </xsl:text>
								<xsl:value-of select="tns:KodKraju"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="tns:NrID"/>
							</xsl:if>
							<xsl:if test="tns:BrakID = '1'">
								<xsl:text>Podmiot nie posiada identyfikatora podatkowego lub identyfikator nie występuje na fakturze </xsl:text>
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>1. Tak</b>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<xsl:if test="tns:Nazwa">
								<xsl:text>Imię i nazwisko lub nazwa: </xsl:text>
								<xsl:value-of select="tns:Nazwa"/>
							</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
				<xsl:if test="tns:Adres">
					<xsl:for-each select="tns:Adres">
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<br/>
								<b>Adres podmiotu trzeciego</b>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:text>Kod kraju: </xsl:text>
								<xsl:apply-templates select="tns:KodKraju"/>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:text>Adres: </xsl:text>
								<xsl:apply-templates select="tns:AdresL1"/>
								<xsl:if test="tns:AdresL2">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="tns:AdresL2"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:if test="tns:GLN">
									<xsl:text>GLN: </xsl:text>
									<xsl:value-of select="tns:GLN"/>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="tns:AdresKoresp">
					<xsl:for-each select="tns:AdresKoresp">
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<br/>
								<b>Adres korespondencyjny podmiotu trzeciego</b>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:text>Kod kraju: </xsl:text>
								<xsl:apply-templates select="tns:KodKraju"/>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:text>Adres: </xsl:text>
								<xsl:apply-templates select="tns:AdresL1"/>
								<xsl:if test="tns:AdresL2">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="tns:AdresL2"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:if test="tns:GLN">
									<xsl:text>GLN: </xsl:text>
									<xsl:value-of select="tns:GLN"/>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="tns:DaneKontaktowe">
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<br/>
							<b>Dane kontaktowe podmiotu trzeciego</b>
						</td>
					</tr>
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<xsl:if test="tns:DaneKontaktowe/tns:Email">
								<xsl:text>Adres e-mail: </xsl:text>
								<xsl:for-each select="tns:DaneKontaktowe/tns:Email">
									<xsl:value-of select="."/>
									<xsl:text>, </xsl:text>
								</xsl:for-each>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<xsl:if test="tns:DaneKontaktowe/tns:Telefon">
								<xsl:text>Numer telefonu: </xsl:text>
								<xsl:for-each select="tns:DaneKontaktowe/tns:Telefon">
									<xsl:value-of select="."/>
									<xsl:text>, </xsl:text>
								</xsl:for-each>
							</xsl:if>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<xsl:if test="tns:Rola">
						<td style="width:50%"/>
						<td style="width:50%">
							<br/>
							<b>
								<xsl:text>Rola</xsl:text>
							</b>
							<br/>
							<xsl:choose>
								<xsl:when test="tns:Rola = '1'">
									<xsl:text>Faktor - w przypadku gdy na fakturze występują dane faktora</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '2'">
									<xsl:text>Odbiorca - w przypadku gdy na fakturze występują dane jednostek wewnętrznych, oddziałów, wyodrębnionych w ramach nabywcy, które same nie stanowią nabywcy w rozumieniu ustawy</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '3'">
									<xsl:text>Podmiot pierwotny - w przypadku gdy na fakturze występują dane podmiotu będącego w stosunku do podatnika podmiotem przejętym lub przekształconym, który dokonywał dostawy lub świadczył usługę. Z wyłączeniem przypadków, o których mowa w art. 106j ust.2 pkt 3 ustawy, gdy dane te wykazywane są w części Podmiot1K</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '4'">
									<xsl:text>Dodatkowy nabywca - w przypadku gdy na fakturze występują dane kolejnych (innych niż wymieniony w części Podmiot2) nabywców</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '5'">
									<xsl:text>Wystawca faktury - w przypadku gdy na fakturze występują dane podmiotu wystawiającego fakturę w imieniu podatnika. Nie dotyczy przypadku, gdy wystawcą faktury jest nabywca</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '6'">
									<xsl:text>Dokonujący płatności - w przypadku gdy na fakturze występują dane podmiotu regulującego zobowiązanie w miejsce nabywcy</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '7'">
									<xsl:text>Jednostka samorządu terytorialnego - wystawca</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '8'">
									<xsl:text>Jednostka samorządu terytorialnego - odbiorca</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '9'">
									<xsl:text>Członek grupy VAT - wystawca</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '10'">
									<xsl:text>Członek grupy VAT - odbiorca</xsl:text>
								</xsl:when>
								<xsl:when test="tns:Rola = '11'">
									<xsl:text>Pracownik</xsl:text>
								</xsl:when>
							</xsl:choose>
						</td>
					</xsl:if>
					<xsl:if test="tns:RolaInna">
						<td style="width:50%"/>
						<td style="width:50%">
							<br/>
							<b>
								<xsl:text>Rola</xsl:text>
							</b>
							<br/>
							<xsl:choose>
								<xsl:when test="tns:RolaInna = '1'">
									<xsl:text>Znacznik innego podmiotu: 1-Inny podmiot </xsl:text>
									<xsl:value-of select="tns:OpisRoli"/>
									<br/>
								</xsl:when>
							</xsl:choose>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td style="width:50%"/>
					<td style="width:50%">
						<xsl:if test="tns:Udzial">
							<br/>
							<xsl:text>Udział: </xsl:text>
							<xsl:value-of select="tns:Udzial"/>%
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td style="width:50%"/>
					<td style="width:50%">
						<xsl:if test="tns:NrKlienta">
							<xsl:text>Numer klienta: </xsl:text>
							<xsl:value-of select="tns:NrKlienta"/>
						</xsl:if>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="PodmiotUpowazniony">
		<xsl:if test="tns:PodmiotUpowazniony">
			<xsl:for-each select="tns:PodmiotUpowazniony">
				<table class="break-word">
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<br/>
							<b>Podmiot upoważniony</b>
						</td>
					</tr>
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<xsl:if test="tns:NrEORI">
								<xsl:text>Numer EORI: </xsl:text>
								<xsl:value-of select="tns:NrEORI"/>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<xsl:text>NIP: </xsl:text>
							<xsl:value-of select="tns:DaneIdentyfikacyjne/tns:NIP"/>
						</td>
					</tr>
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<xsl:text>Imię i nazwisko lub nazwa: </xsl:text>
							<xsl:value-of select="tns:DaneIdentyfikacyjne/tns:Nazwa"/>
						</td>
					</tr>
					<xsl:for-each select="tns:Adres">
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<br/>
								<b>Adres podmiotu upoważnionego</b>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:text>Kod kraju: </xsl:text>
								<xsl:apply-templates select="tns:KodKraju"/>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:text>Adres: </xsl:text>
								<xsl:apply-templates select="tns:AdresL1"/>
								<xsl:if test="tns:AdresL2">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="tns:AdresL2"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:if test="tns:GLN">
									<xsl:text>GLN: </xsl:text>
									<xsl:value-of select="tns:GLN"/>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
					<xsl:if test="tns:AdresKoresp">
						<xsl:for-each select="tns:AdresKoresp">
							<tr>
								<td style="width:50%"/>
								<td style="width:50%">
									<br/>
									<b>Adres korespondencyjny podmiotu upoważnionego</b>
								</td>
							</tr>
							<tr>
								<td style="width:50%"/>
								<td style="width:50%">
									<xsl:text>Kod kraju: </xsl:text>
									<xsl:apply-templates select="tns:KodKraju"/>
								</td>
							</tr>
							<tr>
								<td style="width:50%"/>
								<td style="width:50%">
									<xsl:text>Adres: </xsl:text>
									<xsl:apply-templates select="tns:AdresL1"/>
									<xsl:if test="tns:AdresL2">
										<xsl:text> </xsl:text>
										<xsl:apply-templates select="tns:AdresL2"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width:50%"/>
								<td style="width:50%">
									<xsl:if test="tns:GLN">
										<xsl:text>GLN: </xsl:text>
										<xsl:value-of select="tns:GLN"/>
									</xsl:if>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="tns:DaneKontaktowe">
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<br/>
								<b>Dane kontaktowe podmiotu upoważnionego</b>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:if test="tns:DaneKontaktowe/tns:EmailPU">
									<xsl:text>Adres e-mail: </xsl:text>
									<xsl:for-each select="tns:DaneKontaktowe/tns:EmailPU">
										<xsl:value-of select="."/>
									</xsl:for-each>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width:50%"/>
							<td style="width:50%">
								<xsl:if test="tns:DaneKontaktowe/tns:TelefonPU">
									<xsl:text>Numer telefonu: </xsl:text>
									<xsl:for-each select="tns:DaneKontaktowe/tns:TelefonPU">
										<xsl:value-of select="."/>
									</xsl:for-each>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<br/>
							<b>Rola podmiotu upoważnionego</b>
						</td>
					</tr>
					<tr>
						<td style="width:50%"/>
						<td style="width:50%">
							<xsl:if test="tns:RolaPU">
								<xsl:choose>
									<xsl:when test="tns:RolaPU = '1'">
										<xsl:text>Organ egzekucyjny - w przypadku, o którym mowa w art. 106c pkt 1 ustawy</xsl:text>
									</xsl:when>
									<xsl:when test="tns:RolaPU = '2'">
										<xsl:text>Komornik sądowy - w przypadku, o którym mowa w art. 106c pkt 2 ustawy</xsl:text>
									</xsl:when>
									<xsl:when test="tns:RolaPU = '3'">
										<xsl:text>Przedstawiciel podatkowy - w przypadku gdy na fakturze występują dane przedstawiciela podatkowego, o którym mowa w art. 18a - 18d ustawy</xsl:text>
									</xsl:when>
								</xsl:choose>
							</xsl:if>
						</td>
					</tr>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FakturaWiersze">
		<br/>
		<xsl:if test="tns:Fa/tns:FaWiersz">
			<table class="white-space">
				<tr>
					<td class="niewypelniane">Numer wiersza faktury</td>
					<td class="niewypelniane">Uniwersalny unikalny numer wiersza faktury</td>
					<td class="niewypelniane">Nazwa (rodzaj) towaru lub usługi</td>
					<td class="niewypelniane">Indeks</td>
					<td class="niewypelniane">Jednostka miary</td>
					<td class="niewypelniane">Ilość</td>
					<td class="niewypelniane">Cena jednostkowa</td>
					<td class="niewypelniane">Opusty i obniżki cen</td>
					<td class="niewypelniane">Wartość sprzedaży</td>
					<td class="niewypelniane">Kwota VAT</td>
					<td class="niewypelniane">Stawka podatku</td>
					<td class="niewypelniane">Stawka podatku od wartości dodanej</td>
					<td class="niewypelniane">Data dokonania lub zakończenia dostawy towarów lub wykonania usługi lub data otrzymania zapłaty</td>
					<td class="niewypelniane">Klasyfikacja</td>
					<td class="niewypelniane">Kwota podatku akcyzowego zawarta w cenie towaru</td>
					<td class="niewypelniane">Oznaczenie dotyczące dostawy towarów i świadczenia usług lub procedury</td>
					<td class="niewypelniane">Kurs waluty z Działu VI ustawy</td>
					<td class="niewypelniane">Znacznik dla towaru lub usługi z załącznika nr 15 do ustawy</td>
					<td class="niewypelniane">Znacznik stanu przed korektą</td>
				</tr>
				<xsl:for-each select="tns:Fa/tns:FaWiersz">
					<tr>
						<td class="srodek" width="auto">
							<xsl:value-of select="tns:NrWierszaFa"/>
						</td>
						<td class="lewa" width="auto">
							<xsl:value-of select="tns:UU_ID"/>
						</td>
						<td class="lewa" width="auto">
							<xsl:value-of select="tns:P_7"/>
						</td>
						<td class="lewa" width="auto">
							<xsl:value-of select="tns:Indeks"/>
						</td>
						<td class="lewa" width="auto">
							<xsl:value-of select="tns:P_8A"/>
						</td>
						<td class="prawa" width="auto">
							<xsl:value-of select="tns:P_8B"/>
						</td>
						<td class="prawa" width="auto">
							<xsl:if test="tns:P_9A">
								<xsl:value-of select="tns:P_9A"/> netto
								</xsl:if>
							<xsl:if test="tns:P_9B">
								<br/>
								<xsl:value-of select="tns:P_9B"/> brutto
								</xsl:if>
						</td>
						<td class="prawa" width="auto">
							<xsl:value-of select="tns:P_10"/>
						</td>
						<td class="prawa" width="auto">
							<xsl:if test="tns:P_11">
								<xsl:value-of select="tns:P_11"/> netto
								</xsl:if>
							<xsl:if test="tns:P_11A">
								<br/>
								<xsl:value-of select="tns:P_11A"/> brutto
								</xsl:if>
						</td>
						<td class="prawa" width="auto">
							<xsl:value-of select="tns:P_11Vat"/>
						</td>
						<td class="srodek" width="auto">
							<xsl:choose>
								<xsl:when test="tns:P_12 = '23'">
									<xsl:text>23%</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '22'">
									<xsl:text>22%</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '8'">
									<xsl:text>8%</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '7'">
									<xsl:text>7%</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '5'">
									<xsl:text>5%</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '4'">
									<xsl:text>4%</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '3'">
									<xsl:text>3%</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '0 KR'">
									<xsl:text>0% w przypadku sprzedaży towarów i świadczenia usług na terytorium kraju (z wyłączeniem WDT i eksportu)</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '0 WDT'">
									<xsl:text>0% w przypadku wewnątrzwspólnotowej dostawy towarów (WDT)</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = '0 EX'">
									<xsl:text>0% w przypadku eksportu towarów</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = 'zw'">
									<xsl:text>zwolnione od podatku</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = 'oo'">
									<xsl:text>odwrotne obciążenie</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = 'np I'">
									<xsl:text>niepodlegające opodatkowaniu- dostawy towarów oraz świadczenia usług poza terytorium kraju, z wyłączeniem transakcji, o których mowa w art. 100 ust. 1 pkt 4 ustawy oraz OSS</xsl:text>
								</xsl:when>
								<xsl:when test="tns:P_12 = 'np II'">
									<xsl:text>niepodlegajace opodatkowaniu na terytorium kraju, świadczenie usług  o których mowa w art. 100 ust. 1 pkt 4 ustawy</xsl:text>
								</xsl:when>
							</xsl:choose>
						</td>
						<td class="srodek" width="auto">
							<xsl:if test="tns:P_12_XII">
								<xsl:value-of select="tns:P_12_XII"/>
								<xsl:text>%</xsl:text>
							</xsl:if>
						</td>
						<td class="srodek" width="auto">
							<xsl:value-of select="tns:P_6A"/>
						</td>
						<td class="lewa" width="auto">
							<xsl:if test="tns:GTIN">
									GTIN:
									<xsl:value-of select="tns:GTIN"/>;
							</xsl:if>
							<xsl:if test="tns:PKWiU">
								<xsl:if test="tns:GTIN">
									<br/>
								</xsl:if>
									PKWiU:
									<xsl:value-of select="tns:PKWiU"/>;
							</xsl:if>
							<xsl:if test="tns:CN">
								<xsl:if test="tns:GTIN|tns:PKWiU">
									<br/>
								</xsl:if>
									CN:
									<xsl:value-of select="tns:CN"/>;
							</xsl:if>
							<xsl:if test="tns:PKOB">
								<xsl:if test="tns:GTIN|tns:PKWiU|tns:CN">
									<br/>
								</xsl:if>
									PKOB:
									<xsl:value-of select="tns:PKOB"/>;
							</xsl:if>
						</td>
						<td class="prawa" width="auto">
							<xsl:value-of select="tns:KwotaAkcyzy"/>
						</td>
						<td class="srodek" width="auto">
							<xsl:if test="tns:GTU">
								<xsl:value-of select="tns:GTU"/>
							</xsl:if>
							<xsl:if test="tns:Procedura">
								<xsl:if test="tns:GTU">
									<br/>
								</xsl:if>
								<xsl:value-of select="tns:Procedura"/>
							</xsl:if>
						</td>
						<td class="prawa">
							<xsl:value-of select="tns:KursWaluty"/>
						</td>
						<td class="srodek">
							<xsl:if test="tns:P_12_Zal_15 = '1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>1. Tak</xsl:text>
								</b>
							</xsl:if>
						</td>
						<td class="srodek">
							<xsl:if test="tns:StanPrzed = '1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>1. Tak</xsl:text>
								</b>
							</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:if>
		<br/>
	</xsl:template>
	<xsl:template name="PodliczenieVAT">
		<xsl:if test="tns:Fa/tns:P_13_1|tns:Fa/tns:P_14_1|tns:Fa/tns:P_13_2|tns:Fa/tns:P_14_2|tns:Fa/tns:P_13_3|tns:Fa/tns:P_14_3|tns:Fa/tns:P_13_6_1|tns:Fa/tns:P_13_6_2|tns:Fa/tns:P_13_6_3|tns:Fa/tns:P_13_7|tns:Fa/tns:P_13_4|tns:Fa/tns:P_14_4|tns:Fa/tns:P_13_5">
			<b>Podsumowanie wg stawek</b>
			<br/>
			<br/>
			<table class="break-word" width="60%">
				<tr>
					<td class="niewypelniane" width="12%">Stawka VAT</td>
					<td class="niewypelniane" width="12%">Suma wartości sprzedaży netto</td>
					<td class="niewypelniane" width="12%">Kwota podatku od sumy wartości sprzedaży netto</td>
					<td class="niewypelniane" width="12%">Kwota podatku od sumy wartości sprzedaży netto, przeliczona zgodnie z przepisami Działu VI ustawy</td>
					<td class="niewypelniane" width="12%">Kwota podatku od wartości dodanej w przypadku procedury szczególnej, o której mowa w dziale XII w rozdziale 6a ustawy</td>
					<td>
						<table width="10%">
							<tbody>
								<tr>
									<td/>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_1|tns:Fa/tns:P_14_1">
						<td class="wypelniane" width="12%">
							<xsl:text>22% lub 23%</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_1"/>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_1"/>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_1W"/>
						</td>
						<td class="niewypelniane" width="12%">
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_2|tns:Fa/tns:P_14_2">
						<td class="wypelniane" width="12%">
							<xsl:text>7% lub 8%</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_2"/>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_2"/>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_2W"/>
						</td>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_3|tns:Fa/tns:P_14_3">
						<td class="wypelniane" width="12%">
							<xsl:text>5%</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_3"/>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_3"/>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_3W"/>
						</td>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_6_1">
						<td class="wypelniane" width="12%">
							<xsl:text> 0% krajowe</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_6_1"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_6_2">
						<td class="wypelniane" width="12%">
							<xsl:text> 0% WDT</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_6_2"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_6_3">
						<td class="wypelniane" width="12%">
							<xsl:text>  0% eksport</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_6_3"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_5">
						<td class="wypelniane" width="12%">
							<xsl:text>oss</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_5"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_5"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_7">
						<td class="wypelniane" width="12%">
							<xsl:text>zw</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_7"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_4|tns:Fa/tns:P_14_4|tns:P_14_4W">
						<td class="wypelniane" width="12%">
							<xsl:text>ryczałt taxi</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_4"/>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_4"/>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_14_4W"/>
						</td>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_8">
						<td class="wypelniane" width="12%">
							<xsl:text>np z wyjątkiem art. 100 ust. 1 pkt 4 ustawy</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_8"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_9">
						<td class="wypelniane" width="12%">
							<xsl:text>np wynikające z art. 100 ust. 1 pkt 4 ustawy</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_9"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_10">
						<td class="wypelniane" width="12%">
							<xsl:text>oo</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_10"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="tns:Fa/tns:P_13_11">
						<td class="wypelniane" width="12%">
							<xsl:text>marża</xsl:text>
						</td>
						<td class="prawa" width="12%">
							<xsl:value-of select="tns:Fa/tns:P_13_11"/>
						</td>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
						<td class="niewypelniane" width="12%"/>
					</xsl:if>
				</tr>
			</table>
		</xsl:if>
		<table>
			<tr>
				<td>
					<br/>
					<b>
						<xsl:if test="((tns:Fa/tns:RodzajFaktury = 'VAT') or (tns:Fa/tns:RodzajFaktury = 'KOR') or (tns:Fa/tns:RodzajFaktury = 'UPR'))">
					Kwota należności ogółem:
					</xsl:if>
						<xsl:if test="((tns:Fa/tns:RodzajFaktury = 'ZAL') or (tns:Fa/tns:RodzajFaktury = 'KOR_ZAL'))">
					Otrzymana kwota zapłaty:
					</xsl:if>
						<xsl:if test="((tns:Fa/tns:RodzajFaktury = 'ROZ') or (tns:Fa/tns:RodzajFaktury = 'KOR_ROZ'))">
					Kwota pozostała do zapłaty:
					</xsl:if>
						<xsl:value-of select="tns:Fa/tns:P_15"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="tns:Fa/tns:KodWaluty"/>
					</b>
					<br/>
					<br/>
				</td>
			</tr>
			<xsl:if test="tns:Fa/tns:KursWalutyZ">
				<tr>
					<td>
						Kurs waluty stosowany do wyliczenia kwoty podatku w przypadkach, o których mowa w dziale VI ustawy na fakturach, o których mowa w art. 106b ust. 1 pkt 4 ustawy:
						<b>
							<xsl:value-of select="tns:Fa/tns:KursWalutyZ"/> PLN/<xsl:value-of select="tns:Fa/tns:KodWaluty"/>
						</b>
					<br/>
					<br/>
				</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>
	<xsl:template name="Rozliczenie">
		<xsl:if test="tns:Fa/tns:Rozliczenie">
			<xsl:for-each select="tns:Fa/tns:Rozliczenie">
				<b>Dodatkowe rozliczenia na fakturze</b>
				<br/>
				<br/>
				<xsl:if test="tns:Obciazenia">
					<table>
						<tr>
							<td class="niewypelniane">Obciążenia</td>
						</tr>
					</table>
					<table class="break-word">
						<tr>
							<td class="niewypelniane" width="80%">Powód obciążenia</td>
							<td class="niewypelniane" width="20%">Kwota doliczona do kwoty należności ogółem</td>
						</tr>
						<xsl:for-each select="tns:Obciazenia">
							<tr>
								<td class="wypelniane" width="80%">
									<xsl:value-of select="tns:Powod"/>
								</td>
								<td class="prawa" width="20%">
									<xsl:value-of select="tns:Kwota"/>
								</td>
							</tr>
						</xsl:for-each>
						<tr>
							<td class="niewypelniane" width="20%">Suma obciążeń</td>
							<td class="prawa" width="80%">
								<xsl:value-of select="tns:SumaObciazen"/>
							</td>
						</tr>
					</table>
				</xsl:if>
				<br/>
				<xsl:if test="tns:Odliczenia">
					<table>
						<tr>
							<td class="niewypelniane">Odliczenia</td>
						</tr>
					</table>
					<table class="break-word">
						<tr>
							<td class="niewypelniane" width="80%">Powód odliczenia</td>
							<td class="niewypelniane" width="20%">Kwota odliczona od kwoty należności ogółem</td>
						</tr>
						<xsl:for-each select="tns:Odliczenia">
							<tr>
								<td class="wypelniane" width="80%">
									<xsl:value-of select="tns:Powod"/>
								</td>
								<td class="prawa" width="20%">
									<xsl:value-of select="tns:Kwota"/>
								</td>
							</tr>
						</xsl:for-each>
						<tr>
							<td class="niewypelniane" width="20%">Suma odliczeń</td>
							<td class="prawa" width="80%">
								<xsl:value-of select="tns:SumaOdliczen"/>
							</td>
						</tr>
					</table>
					<br/>
					<b>Do zapłaty / Do rozliczenia</b>
					<br/>
					<br/>
					<table class="break-word">
						<tr>
							<xsl:choose>
								<xsl:when test="tns:DoZaplaty">
									<td class="niewypelniane" width="20%">Kwota należności do zapłaty równa kwocie należności ogółem powiększonej o sumę obciążeń i pomniejszonej o sumę odliczeń.</td>
									<td class="prawa" width="80%">
										<xsl:value-of select="tns:DoZaplaty"/>
									</td>
								</xsl:when>
								<xsl:when test="tns:DoRozliczenia">
									<td class="niewypelniane" width="20%">Kwota nadpłacona do rozliczenia/zwrotu</td>
									<td class="prawa" width="80%">
										<xsl:value-of select="tns:DoRozliczenia"/>
									</td>
								</xsl:when>
							</xsl:choose>
						</tr>
					</table>
				</xsl:if>
				<br/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Platnosc">
		<xsl:for-each select="tns:Fa/tns:Platnosc">
			<b>Warunki płatności</b>
			<br/>
			<xsl:if test="tns:Zaplacono|tns:DataZaplaty">
				<xsl:if test="tns:Zaplacono = '1'">
					<table class="break-word" width="100%">
						<tr>
							<td>
								Znacznik informujący, że należność wynikająca z faktury została zapłacona:
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>1. zapłacono</b>
							</td>
						</tr>
						<tr>
							<td>
								Data zapłaty, jeśli do wystawienia faktury płatność została dokonana:
								<b>
									<xsl:value-of select="tns:DataZaplaty"/>
								</b>
							</td>
						</tr>
					</table>
				</xsl:if>
			</xsl:if>
			<xsl:if test="tns:ZnacznikZaplatyCzesciowej|tns:ZaplataCzesciowa">
				<table class="normalna" width="60%">
					<br/>
					<tr>
						<td class="niewypelniane" width="20%">Znacznik informujący, że należność wynikająca z faktury została zapłacona w części lub w całości:</td>
						<td class="wypelniane, srodek" width="80%">
							<xsl:choose>
								<xsl:when test="tns:ZnacznikZaplatyCzesciowej = '1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									<b>1 - zapłacono w części</b>
								</xsl:when>
								<xsl:when test="tns:ZnacznikZaplatyCzesciowej = '2'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									<b>2 - zapłacono w całości, jeśli należność wynikająca z faktury została zapłacona w dwóch lub więcej częściach, a ostatnia płatność jest płatnością końcową</b>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
				</table>
				<table class="normalna">
					<tr>
						<td class="niewypelniane" colspan="4">Dane zapłat częściowych</td>
					</tr>
					<tr>
						<td class="niewypelniane" width="15%">Kwota zapłaty częściowej</td>
						<td class="niewypelniane" width="15%">Data zapłaty częściowej, jeśli do wystawienia faktury płatność częściowa została dokonana</td>
						<td class="niewypelniane" width="15%">Forma płatności / Znacznik innej formy płatności</td>
						<td class="niewypelniane" width="55%">Uszczegółowienie innej formy płatności</td>
					</tr>
					<xsl:for-each select="tns:ZaplataCzesciowa">
						<tr>
							<td class="prawa" width="15%">
								<xsl:value-of select="tns:KwotaZaplatyCzesciowej"/>
							</td>
							<td class="srodek" width="15%">
								<xsl:value-of select="tns:DataZaplatyCzesciowej"/>
								<br/>
							</td>
							<td class="srodek" width="15%">
								<xsl:if test="tns:FormaPlatnosci">
									<xsl:choose>
										<xsl:when test="tns:FormaPlatnosci = '1'">
											<xsl:text>Gotówka</xsl:text>
										</xsl:when>
										<xsl:when test="tns:FormaPlatnosci = '2'">
											<xsl:text>Karta</xsl:text>
										</xsl:when>
										<xsl:when test="tns:FormaPlatnosci = '3'">
											<xsl:text>Bon</xsl:text>
										</xsl:when>
										<xsl:when test="tns:FormaPlatnosci = '4'">
											<xsl:text>Czek</xsl:text>
										</xsl:when>
										<xsl:when test="tns:FormaPlatnosci = '5'">
											<xsl:text>Kredyt</xsl:text>
										</xsl:when>
										<xsl:when test="tns:FormaPlatnosci = '6'">
											<xsl:text>Przelew</xsl:text>
										</xsl:when>
										<xsl:when test="tns:FormaPlatnosci = '7'">
											<xsl:text>Mobilna</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="tns:PlatnoscInna = '1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									1 - inna forma płatności
								</xsl:if>
							</td>
							<td class="lewa" width="55%">
								<xsl:value-of select="tns:OpisPlatnosci"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>
			<xsl:if test="tns:TerminPlatnosci">
				<br/>
				<table class="break-word">
					<tr>
						<td class="niewypelniane" width="20%">Termin płatności</td>
						<td class="niewypelniane" width="80%">Opis terminu płatności</td>
					</tr>
					<xsl:for-each select="tns:TerminPlatnosci">
						<tr>
							<td class="srodek" width="20%">
								<xsl:value-of select="tns:Termin"/>
							</td>
							<td class="wypelniane" width="80%">
								<xsl:value-of select="tns:TerminOpis"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>
			<xsl:if test="tns:FormaPlatnosci">
				<br/>
				<table class="normalna">
					<tr>
						<td class="niewypelniane" width="20%">Forma płatności</td>
					</tr>
					<tr>
						<td class="wypelniane" width="20%">
							<xsl:choose>
								<xsl:when test="tns:FormaPlatnosci = '1'">
									<xsl:text>Gotówka</xsl:text>
								</xsl:when>
								<xsl:when test="tns:FormaPlatnosci = '2'">
									<xsl:text>Karta</xsl:text>
								</xsl:when>
								<xsl:when test="tns:FormaPlatnosci = '3'">
									<xsl:text>Bon</xsl:text>
								</xsl:when>
								<xsl:when test="tns:FormaPlatnosci = '4'">
									<xsl:text>Czek</xsl:text>
								</xsl:when>
								<xsl:when test="tns:FormaPlatnosci = '5'">
									<xsl:text>Kredyt</xsl:text>
								</xsl:when>
								<xsl:when test="tns:FormaPlatnosci = '6'">
									<xsl:text>Przelew</xsl:text>
								</xsl:when>
								<xsl:when test="tns:FormaPlatnosci = '7'">
									<xsl:text>Mobilna</xsl:text>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
				</table>
			</xsl:if>
			<xsl:if test="tns:PlatnoscInna">
				<br/>
				<table class="break-word">
					<tr>
						<td class="niewypelniane" width="20%">Znacznik innej formy płatności:</td>
						<td class="niewypelniane" width="80%">Uszczegółowienie innej formy płatności</td>
					</tr>
					<tr>
						<td class="wypelniane, srodek" width="20%">
							<xsl:if test="tns:PlatnoscInna = '1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>1. Tak</b>
							</xsl:if>
						</td>
						<td class="wypelniane" width="80%">
							<xsl:value-of select="tns:OpisPlatnosci"/>
						</td>
					</tr>
				</table>
			</xsl:if>
			<xsl:if test="tns:RachunekBankowy">
				<br/>
				<b>Rachunek bankowy</b>
				<table class="break-word">
					<tr>
						<br/>
						<td class="niewypelniane" width="22%">Pełny numer rachunku<br/>Kod SWIFT</td>
						<td class="niewypelniane" width="16%">Rachunek własny banku</td>
						<td class="niewypelniane" width="31%">Nazwa</td>
						<td class="niewypelniane" width="31%">Opis rachunku</td>
					</tr>
					<xsl:for-each select="tns:RachunekBankowy">
						<tr>
							<td class="wypelniane" width="22%">
								<xsl:value-of select="tns:NrRB"/>
								<br/>
								<xsl:if test="tns:SWIFT">
									SWIFT:
									<xsl:value-of select="tns:SWIFT"/>
								</xsl:if>
							</td>
							<td class="wypelniane" width="16%">
								<xsl:choose>
									<xsl:when test="tns:RachunekWlasnyBanku = '1'">
										<xsl:text>Rachunek banku lub rachunek spółdzielczej kasy oszczędnościowo-kredytowej służący do dokonywania rozliczeń z tytułu nabywanych przez ten bank lub tę kasę wierzytelności pieniężnych</xsl:text>
									</xsl:when>
									<xsl:when test="tns:RachunekWlasnyBanku = '2'">
										<xsl:text>Rachunek banku lub rachunek spółdzielczej kasy oszczędnościowo-kredytowej wykorzystywany przez ten bank lub tę kasę do pobrania należności od nabywcy towarów lub usług za dostawę towarów lub świadczenie usług, potwierdzone fakturą, i przekazania jej w całości albo części dostawcy towarów lub usługodawcy</xsl:text>
									</xsl:when>
									<xsl:when test="tns:RachunekWlasnyBanku = '3'">
										<xsl:text>Rachunek banku lub rachunek spółdzielczej kasy oszczędnościowo-kredytowej prowadzony przez ten bank lub tę kasę w ramach gospodarki własnej, niebędący rachunkiem rozliczeniowym</xsl:text>
									</xsl:when>
								</xsl:choose>
							</td>
							<td class="wypelniane" width="31%">
								<xsl:value-of select="tns:NazwaBanku"/>
							</td>
							<td class="wypelniane" width="31%">
								<xsl:value-of select="tns:OpisRachunku"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>
			<xsl:if test="tns:RachunekBankowyFaktora">
				<br/>
				<b>Rachunek faktora</b>
				<table class="break-word">
					<tr>
						<br/>
						<td class="niewypelniane" width="22%">Pełny numer rachunku<br/>Kod SWIFT</td>
						<td class="niewypelniane" width="16%">Rachunek własny banku</td>
						<td class="niewypelniane" width="31%">Nazwa</td>
						<td class="niewypelniane" width="31%">Opis rachunku</td>
					</tr>
					<xsl:for-each select="tns:RachunekBankowyFaktora">
						<tr>
							<td class="wypelniane" width="22%">
								<xsl:value-of select="tns:NrRB"/>
								<br/>
								<xsl:if test="tns:SWIFT">
									SWIFT:
									<xsl:value-of select="tns:SWIFT"/>
								</xsl:if>
							</td>
							<td class="wypelniane" width="16%">
								<xsl:choose>
									<xsl:when test="tns:RachunekWlasnyBanku = '1'">
										<xsl:text>Rachunek banku lub rachunek spółdzielczej kasy oszczędnościowo-kredytowej służący do dokonywania rozliczeń z tytułu nabywanych przez ten bank lub tę kasę wierzytelności pieniężnych</xsl:text>
									</xsl:when>
									<xsl:when test="tns:RachunekWlasnyBanku = '2'">
										<xsl:text>Rachunek banku lub rachunek spółdzielczej kasy oszczędnościowo-kredytowej wykorzystywany przez ten bank lub tę kasę do pobrania należności od nabywcy towarów lub usług za dostawę towarów lub świadczenie usług, potwierdzone fakturą, i przekazania jej w całości albo części dostawcy towarów lub usługodawcy</xsl:text>
									</xsl:when>
									<xsl:when test="tns:RachunekWlasnyBanku = '3'">
										<xsl:text>Rachunek banku lub rachunek spółdzielczej kasy oszczędnościowo-kredytowej prowadzony przez ten bank lub tę kasę w ramach gospodarki własnej, niebędący rachunkiem rozliczeniowym</xsl:text>
									</xsl:when>
								</xsl:choose>
							</td>
							<td class="wypelniane" width="31%">
								<xsl:value-of select="tns:NazwaBanku"/>
							</td>
							<td class="wypelniane" width="31%">
								<xsl:value-of select="tns:OpisRachunku"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>
			<br/>
			<xsl:if test="tns:Skonto">
				<b>Skonto</b>
				<br/>
				<table class="break-word">
					<tr>
						<br/>
						<td class="niewypelniane" width="50%">
						Warunki, które nabywca powinien spełnić, aby skorzystać ze skonta
						</td>
						<td class="niewypelniane" width="50%">
						Wysokość skonta
						</td>
					</tr>
					<tr>
						<td class="wypelniane" width="50%">
							<xsl:value-of select="tns:Skonto/tns:WarunkiSkonta"/>
						</td>
						<td class="wypelniane" width="50%">
							<xsl:value-of select="tns:Skonto/tns:WysokoscSkonta"/>
						</td>
					</tr>
				</table>
				<br/>
			</xsl:if>
			<xsl:if test="tns:LinkDoPlatnosci">
				<div>Link do płatności bezgotówkowej -
					<b>
						<xsl:value-of select="tns:LinkDoPlatnosci"/>
					</b>
				</div>
				<br/>
			</xsl:if>
			<xsl:if test="tns:IPKSeF">
				<div>Identyfikator płatności Krajowego Systemu e-Faktur -
					<b>
						<xsl:value-of select="tns:IPKSeF"/>
					</b>
				</div>
				<br/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="Adnotacje">
		<b>Adnotacje</b>
		<br/>
		<xsl:for-each select="tns:Fa/tns:Adnotacje">
			<br/>
			<table class="break-word">
				<tr>
					<td class="niewypelniane" width="25%">Metoda kasowa</td>
					<td class="niewypelniane" width="25%">Samofakturowanie</td>
					<td class="niewypelniane" width="25%">Odwrotne obciążenie</td>
					<td class="niewypelniane" width="25%">Mechanizm podzielonej płatności</td>
				</tr>
				<tr>
					<td class="wypelniane, srodek" width="25%">
						<xsl:choose>
							<xsl:when test="tns:P_16 = '1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>1. Tak</xsl:text>
								</b>
							</xsl:when>
							<xsl:when test="tns:P_16 = '2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>2. Nie</xsl:text>
								</b>
							</xsl:when>
						</xsl:choose>
					</td>
					<td class="wypelniane, srodek" width="25%">
						<xsl:choose>
							<xsl:when test="tns:P_17 = '1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>1. Tak</xsl:text>
								</b>
							</xsl:when>
							<xsl:when test="tns:P_17 = '2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>2. Nie</xsl:text>
								</b>
							</xsl:when>
						</xsl:choose>
					</td>
					<td class="wypelniane, srodek" width="25%">
						<xsl:choose>
							<xsl:when test="tns:P_18 = '1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>1. Tak</xsl:text>
								</b>
							</xsl:when>
							<xsl:when test="tns:P_18 = '2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>2. Nie</xsl:text>
								</b>
							</xsl:when>
						</xsl:choose>
					</td>
					<td class="wypelniane, srodek" width="25%">
						<xsl:choose>
							<xsl:when test="tns:P_18A = '1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>1. Tak</xsl:text>
								</b>
							</xsl:when>
							<xsl:when test="tns:P_18A = '2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>2. Nie</xsl:text>
								</b>
							</xsl:when>
						</xsl:choose>
					</td>
				</tr>
			</table>
			<br/>
			<xsl:for-each select="tns:Zwolnienie">
				<xsl:if test="tns:P_19">
					<table class="break-word">
						<tr>
							<td class="niewypelniane" width="25%">Dostawy towarów lub świadczenia usług zwolnionych</td>
							<td class="niewypelniane" width="75%">Przepis, na podstawie którego podatnik stosuje zwolnienie od podatku </td>
						</tr>
						<tr>
							<td class="wypelniane, srodek" width="25%">
								<xsl:choose>
									<xsl:when test="tns:P_19 = '1'">
										<input type="checkbox" checked="checked" disabled="disabled"/>
										<b>
											<xsl:text>1. Tak</xsl:text>
										</b>
									</xsl:when>
									<xsl:when test="tns:P_19 = '2'">
										<input type="checkbox" checked="checked" disabled="disabled"/>
										<b>
											<xsl:text>2. Nie</xsl:text>
										</b>
									</xsl:when>
								</xsl:choose>
							</td>
							<td class="wypelniane" width="75%">
								<xsl:if test="tns:P_19A">
									<xsl:value-of select="tns:P_19A"/>
								</xsl:if>
								<xsl:if test="tns:P_19B">
									<xsl:value-of select="tns:P_19B"/>
								</xsl:if>
								<xsl:if test="tns:P_19C">
									<xsl:value-of select="tns:P_19C"/>
								</xsl:if>
							</td>
						</tr>
					</table>
				</xsl:if>
				<xsl:if test="tns:P_19N = '1'">
					Znacznik braku dostawy towarów lub świadczenia usług zwolnionych od podatku na podstawie art. 43 ust. 1, art. 113 ust. 1 i 9 ustawy albo przepisów wydanych na podstawie art. 82 ust. 3 ustawy lub na podstawie innych przepisów -
					<input type="checkbox" checked="checked" disabled="disabled"/>
					<b>1. Tak</b>
					<br/>
				</xsl:if>
			</xsl:for-each>
			<br/>
			<xsl:if test="tns:NoweSrodkiTransportu/tns:P_22 = '1'">
				<xsl:for-each select="tns:NoweSrodkiTransportu">
					<div>Wewnątrzwspólnotowa dostawa nowych środków transportu -
						<input type="checkbox" checked="checked" disabled="disabled"/>
						<b>1. Tak</b>
					</div>
					<div>Występuje obowiązek, o którym mowa w art. 42 ust. 5 ustawy -
						<input type="checkbox" checked="checked" disabled="disabled"/>
						<xsl:if test="tns:P_42_5 = '1'">
							<b>1. Tak</b>
						</xsl:if>
						<xsl:if test="tns:P_42_5 = '2'">
							<b>2. Nie</b>
						</xsl:if>
					</div>
					<br/>
					<table class="break-word">
						<tr>
							<td class="niewypelniane">Data dopuszczenia nowego środka transportu do użytku</td>
							<td class="niewypelniane">Numer wiersza faktury, w którym wykazano dostawę nowego środka transportu</td>
							<td class="niewypelniane">Marka nowego środka transportu</td>
							<td class="niewypelniane">Model nowego środka transportu</td>
							<td class="niewypelniane">Kolor nowego środka transportu</td>
							<td class="niewypelniane">Numer rejestracyjny nowego środka transportu</td>
							<td class="niewypelniane">Rok produkcji nowego środka transportu</td>
							<td class="niewypelniane">Przebieg (dotyczy pojazdu lądowego)</td>
							<td class="niewypelniane">VIN lub numer nadwozia lub numer podwozia lub numer ramy (dotyczy pojazdu lądowego)</td>
							<td class="niewypelniane">Typ nowego środka transportu (dotyczy pojazdu lądowego)</td>
							<td class="niewypelniane">Liczba godzin roboczych (dotyczy jednostek pływających)</td>
							<td class="niewypelniane">Numer kadłuba (dotyczy jednostek pływających)</td>
							<td class="niewypelniane">Liczba godzin roboczych (dotyczy statków powietrznych)</td>
							<td class="niewypelniane">Numer fabryczny (dotyczy statków powietrznych)</td>
						</tr>
						<xsl:for-each select="tns:NowySrodekTransportu">
							<tr>
								<td class="srodek" width="auto">
									<xsl:value-of select="tns:P_22A"/>
								</td>
								<td class="srodek" width="auto">
									<xsl:value-of select="tns:P_NrWierszaNST"/>
								</td>
								<td class="srodek" width="auto">
									<xsl:value-of select="tns:P_22BMK"/>
								</td>
								<td class="srodek" width="auto">
									<xsl:value-of select="tns:P_22BMD"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22BK"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22BNR"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22BRP"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22B"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:if test="tns:P_22B1">
										<xsl:value-of select="tns:P_22B1"/>
									</xsl:if>
									<xsl:if test="tns:P_22B2">
										<xsl:value-of select="tns:P_22B2"/>
									</xsl:if>
									<xsl:if test="tns:P_22B3">
										<xsl:value-of select="tns:P_22B3"/>
									</xsl:if>
									<xsl:if test="tns:P_22B4">
										<xsl:value-of select="tns:P_22B4"/>
									</xsl:if>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22BT"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22C"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22C1"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22D"/>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:value-of select="tns:P_22D1"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="tns:NoweSrodkiTransportu/tns:P_22N = '1'">
				<div>Brak wewnątrzwspólnotowej dostawy nowych środków transportu -
						<input type="checkbox" checked="checked" disabled="disabled"/>
					<b>1. Tak</b>
				</div>
			</xsl:if>
			<br/>
			<br/>
			<div>VAT: Faktura WE uproszczona na mocy art. 135-138 ustawy o ptu. Podatek z tytułu dokonanej dostawy zostanie rozliczony przez ostatniego w kolejności podatnika podatku od wartości dodanej:
				<xsl:choose>
					<xsl:when test="tns:P_23 = '1'">
						<b>
							<input type="checkbox" checked="checked" disabled="disabled"/>
							<xsl:text>1. Tak</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="tns:P_23 = '2'">
						<b>
							<input type="checkbox" checked="checked" disabled="disabled"/>
							<xsl:text>2. Nie</xsl:text>
						</b>
					</xsl:when>
				</xsl:choose>
			</div>
			<br/>
			<xsl:for-each select="tns:PMarzy">
				<xsl:choose>
					<xsl:when test="tns:P_PMarzy = '1'">
						<div>Wystąpienie procedur marży, o których mowa w art. 119 lub art. 120 ustawy:
						<b>
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<xsl:text>1. Tak</xsl:text>
							</b>
						</div>
					</xsl:when>
					<xsl:when test="tns:P_PMarzyN = '1'">
						<div>Brak wystąpienia procedur marży, o których mowa w art. 119 lub art. 120 ustawy:
						<b>
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<xsl:text>1. Tak</xsl:text>
							</b>
						</div>
					</xsl:when>
				</xsl:choose>
				<br/>
				<xsl:if test="tns:P_PMarzy = '1'">
					<table class="normalna">
						<tr>
							<td class="niewypelniane" width="25%">Procedura marży dla biur podróży</td>
							<td class="niewypelniane" width="25%">Procedura marży - towary używane</td>
							<td class="niewypelniane" width="25%">Procedura marży - dzieła sztuki</td>
							<td class="niewypelniane" width="25%">Procedura marży - przedmioty kolekcjonerskie i antyki</td>
						</tr>
						<tr>
							<td class="wypelniane, srodek" width="25%">
								<xsl:if test="tns:P_PMarzy_2 = '1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									<b>
										<xsl:text>1. Tak</xsl:text>
									</b>
								</xsl:if>
							</td>
							<td class="wypelniane, srodek" width="25%">
								<xsl:if test="tns:P_PMarzy_3_1 = '1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									<b>
										<xsl:text>1. Tak</xsl:text>
									</b>
								</xsl:if>
							</td>
							<td class="wypelniane, srodek" width="25%">
								<xsl:if test="tns:P_PMarzy_3_2 = '1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									<b>
										<xsl:text>1. Tak</xsl:text>
									</b>
								</xsl:if>
							</td>
							<td class="wypelniane, srodek" width="25%">
								<xsl:if test="tns:P_PMarzy_3_3 = '1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									<b>
										<xsl:text>1. Tak</xsl:text>
									</b>
								</xsl:if>
							</td>
						</tr>
					</table>
				</xsl:if>
			</xsl:for-each>
			<br/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="WarunkiTransakcji">
		<xsl:if test="tns:Fa/tns:WarunkiTransakcji">
			<xsl:for-each select="tns:Fa/tns:WarunkiTransakcji">
				<b>Warunki transakcji</b>
				<br/>
				<br/>
				<xsl:if test="tns:Umowy">
					<table>
						<tr>
							<td class="niewypelniane">Umowy</td>
						</tr>
					</table>
					<table class="break-word">
						<tr>
							<td class="niewypelniane" width="20%">Data umowy</td>
							<td class="niewypelniane" width="80%">Numer umowy</td>
						</tr>
						<xsl:for-each select="tns:Umowy">
							<tr>
								<td class="srodek" width="20%">
									<xsl:if test="tns:DataUmowy">
										<xsl:value-of select="tns:DataUmowy"/>
										<br/>
									</xsl:if>
								</td>
								<td class="wypelniane" width="80%">
									<xsl:if test="tns:NrUmowy">
										<xsl:value-of select="tns:NrUmowy"/>
										<br/>
									</xsl:if>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:if>
				<br/>
				<xsl:if test="tns:Zamowienia">
					<table>
						<tr>
							<td class="niewypelniane">Zamówienia</td>
						</tr>
					</table>
					<table class="break-word">
						<tr>
							<td class="niewypelniane" width="20%">Data zamówienia</td>
							<td class="niewypelniane" width="80%">Numer zamówienia</td>
						</tr>
						<xsl:for-each select="tns:Zamowienia">
							<tr>
								<td class="srodek" width="20%">
									<xsl:if test="tns:DataZamowienia">
										<xsl:value-of select="tns:DataZamowienia"/>
										<br/>
									</xsl:if>
								</td>
								<td class="wypelniane" width="80%">
									<xsl:if test="tns:NrZamowienia">
										<xsl:value-of select="tns:NrZamowienia"/>
										<br/>
									</xsl:if>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:if>
				<br/>
				<xsl:if test="tns:NrPartiiTowaru">
					<table class="break-word" width="100%">
						<tr>
							<td class="niewypelniane" width="20%">Numer partii towaru</td>
							<td class="wypelniane" width="80%">
								<xsl:for-each select="tns:NrPartiiTowaru">
									<xsl:number value="position()" format="1. "/>
									<xsl:value-of select="."/>
									<br/>
								</xsl:for-each>
							</td>
						</tr>
					</table>
					<br/>
				</xsl:if>
				<xsl:if test="tns:WarunkiDostawy">
					<table class="break-word" width="100%">
						<tr>
							<td class="niewypelniane" width="20%">Warunki dostawy towarów - w przypadku istnienia pomiędzy stronami transakcji, umowy określającej warunki dostawy tzw. Incoterms</td>
							<td class="wypelniane" width="80%">
								<xsl:value-of select="tns:WarunkiDostawy"/>
							</td>
						</tr>
					</table>
					<br/>
				</xsl:if>
				<xsl:if test="tns:KursUmowny|tns:WalutaUmowna">
					<table width="100%">
						<tr>
							<td class="niewypelniane" width="50%">Kurs umowny - w przypadkach, gdy na fakturze znajduje się informacja o kursie, po którym zostały przeliczone kwoty wykazane na fakturze w złotych. Nie dotyczy przypadków, o których mowa w dziale VI ustawy</td>
							<td class="niewypelniane" width="50%">Waluta umowna - kod waluty (ISO-4217) w przypadkach gdy na fakturze znajduje się informacja o kursie, po którym zostały przeliczone kwoty wykazane na fakturze w złotych. Nie dotyczy przypadków, o których mowa w dziale VI ustawy</td>
						</tr>
						<tr>
							<td class="wypelniane, prawa" width="50%">
								<xsl:value-of select="tns:KursUmowny"/>
							</td>
							<td class="wypelniane" width="50%">
								<xsl:value-of select="tns:WalutaUmowna"/>
							</td>
						</tr>
					</table>
					<br/>
				</xsl:if>
				<xsl:if test="tns:Transport">
					<xsl:for-each select="tns:Transport">
						<table width="100%">
							<tr>
								<td class="niewypelniane" colspan="2">Transport <xsl:number value="position()" format="(1) "/>
								</td>
							</tr>
						</table>
						<xsl:if test="tns:RodzajTransportu">
							<table width="100%">
								<tr>
									<td class="niewypelniane" width="30%">Rodzaj zastosowanego transportu w przypadku dokonanej dostawy towarów</td>
									<td class="wypelniane" width="70%">
										<xsl:choose>
											<xsl:when test="tns:RodzajTransportu = '1'">
												<xsl:text>Transport morski</xsl:text>
											</xsl:when>
											<xsl:when test="tns:RodzajTransportu = '2'">
												<xsl:text>Transport kolejowy</xsl:text>
											</xsl:when>
											<xsl:when test="tns:RodzajTransportu = '3'">
												<xsl:text>Transport drogowy</xsl:text>
											</xsl:when>
											<xsl:when test="tns:RodzajTransportu = '4'">
												<xsl:text>Transport lotniczy</xsl:text>
											</xsl:when>
											<xsl:when test="tns:RodzajTransportu = '5'">
												<xsl:text>Przesyłka pocztowa</xsl:text>
											</xsl:when>
											<xsl:when test="tns:RodzajTransportu = '7'">
												<xsl:text>Stałe instalacje przesyłowe</xsl:text>
											</xsl:when>
											<xsl:when test="tns:RodzajTransportu = '8'">
												<xsl:text>Żegluga śródlądowa</xsl:text>
											</xsl:when>
										</xsl:choose>
									</td>
								</tr>
							</table>
						</xsl:if>
						<xsl:if test="tns:TransportInny">
							<table width="100%">
								<tr>
									<td class="niewypelniane">Inny rodzaj transportu</td>
									<td class="niewypelniane">Opis innego rodzaju transportu</td>
								</tr>
								<tr>
									<td class="wypelniane">
										<xsl:if test="tns:TransportInny ='1'">
											<input type="checkbox" checked="checked" disabled="disabled"/>
											<b>
												<xsl:text>1. Tak</xsl:text>
											</b>
										</xsl:if>
									</td>
									<td class="wypelniane">
										<xsl:value-of select="tns:OpisInnegoTransportu"/>
									</td>
								</tr>
							</table>
						</xsl:if>
						<xsl:for-each select="tns:Przewoznik/tns:DaneIdentyfikacyjne">
							<table class="break-word">
								<tr>
									<td class="niewypelniane" colspan="2">Dane identyfikacyjne przewoźnika</td>
								</tr>
								<tr>
									<td class="niewypelniane" width="20%" rowspan="4">Dane identyfikacyjne przewoźnika</td>
									<td class="wypelniane" width="80%">
										<xsl:if test="tns:NIP">
											<xsl:text>NIP: </xsl:text>
											<xsl:value-of select="tns:NIP"/>
										</xsl:if>
										<xsl:if test="tns:KodUE|tns:NrVatUE">
											<xsl:text>Kod (prefiks) nabywcy VAT UE: </xsl:text>
											<xsl:value-of select="tns:KodUE"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="tns:NrVatUE"/>
										</xsl:if>
										<xsl:if test="tns:NrID">
											<xsl:text>Identyfikator podatkowy inny: </xsl:text>
											<xsl:value-of select="tns:KodKraju"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="tns:NrID"/>
										</xsl:if>
										<xsl:if test="tns:BrakID = '1'">
											<xsl:text>Podmiot nie posiada identyfikatora podatkowego: </xsl:text>
											<input type="checkbox" checked="checked" disabled="disabled"/>
											<b>
												<xsl:text>1. Tak</xsl:text>
											</b>
										</xsl:if>
									</td>
								</tr>
							</table>
							<table class="break-word">
								<xsl:if test="tns:Nazwa">
									<tr>
										<td class="niewypelniane" width="20%" rowspan="4">Imię i nazwisko lub nazwa</td>
										<td class="wypelniane" width="80%">
											<xsl:value-of select="tns:Nazwa"/>
										</td>
									</tr>
								</xsl:if>
							</table>
						</xsl:for-each>
						<xsl:for-each select="tns:Przewoznik/tns:AdresPrzewoznika">
							<table class="break-word">
								<tr>
									<td class="niewypelniane">Adres przewoźnika</td>
								</tr>
							</table>
							<table class="break-word">
								<tr>
									<td class="niewypelniane" width="10%">Kod kraju</td>
									<td class="niewypelniane" width="80%">Adres</td>
									<td class="niewypelniane" width="10%">GLN</td>
								</tr>
								<tr>
									<td class="srodek" style="width:10%">
										<xsl:apply-templates select="tns:KodKraju"/>
									</td>
									<td class="lewa" style="width:80%">
										<xsl:apply-templates select="tns:AdresL1"/>
										<xsl:if test="tns:AdresL2">
											<xsl:text> </xsl:text>
											<xsl:apply-templates select="tns:AdresL2"/>
										</xsl:if>
									</td>
									<td class="srodek" style="width:10%">
										<xsl:if test="tns:GLN">
											<xsl:value-of select="tns:GLN"/>
										</xsl:if>
									</td>
								</tr>
							</table>
							<br/>
						</xsl:for-each>
						<xsl:if test="tns:NrZleceniaTransportu">
							<table class="break-word" width="100%">
								<tr>
									<td class="niewypelniane" width="20%">Numer zlecenia transportu:</td>
									<td class="wypelniane" width="80%">
										<xsl:value-of select="tns:NrZleceniaTransportu"/>
									</td>
								</tr>
							</table>
						</xsl:if>
						<table class="break-word">
							<xsl:if test="tns:OpisLadunku">
								<tr>
									<td class="niewypelniane" width="20%">Opis ładunku</td>
									<td class="wypelniane" width="80%">
										<xsl:choose>
											<xsl:when test="tns:OpisLadunku = '1'">
												<xsl:text>Bańka</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '2'">
												<xsl:text>Beczka</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '3'">
												<xsl:text>Butla</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '4'">
												<xsl:text>Karton</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '5'">
												<xsl:text>Kanister</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '6'">
												<xsl:text>Klatka</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '7'">
												<xsl:text>Kontener</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '8'">
												<xsl:text>Kosz/koszyk</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '9'">
												<xsl:text>Łubianka</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '10'">
												<xsl:text>Opakowanie zbiorcze</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '11'">
												<xsl:text>Paczka</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '12'">
												<xsl:text>Pakiet</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '13'">
												<xsl:text>Paleta</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '14'">
												<xsl:text>Pojemnik</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '15'">
												<xsl:text>Pojemnik do ładunków masowych stałych</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '16'">
												<xsl:text>Pojemnik do ładunków masowych w postaci płynnej</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '17'">
												<xsl:text>Pudełko</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '18'">
												<xsl:text>Puszka</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '19'">
												<xsl:text>Skrzynia</xsl:text>
											</xsl:when>
											<xsl:when test="tns:OpisLadunku = '20'">
												<xsl:text>Worek</xsl:text>
											</xsl:when>
										</xsl:choose>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="tns:LadunekInny = '1'">
								<tr>
									<td class="niewypelniane" width="20%">Znacznik innego ładunku:</td>
									<td class="wypelniane" width="80%">
										<input type="checkbox" checked="checked" disabled="disabled"/>
										<b>
											<xsl:text>1. Tak</xsl:text>
										</b>
									</td>
								</tr>
								<tr>
									<td class="niewypelniane" width="20%">Opis innego ładunku, w tym ładunek mieszany</td>
									<td class="wypelniane" width="80%">
										<xsl:value-of select="tns:OpisInnegoLadunku"/>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="tns:JednostkaOpakowania">
								<tr>
									<td class="niewypelniane" width="20%">Jednostka opakowania</td>
									<td class="wypelniane" width="80%">
										<xsl:value-of select="tns:JednostkaOpakowania"/>
									</td>
								</tr>
							</xsl:if>
						</table>
						<br/>
						<table class="break-word">
							<tr>
								<td class="niewypelniane">Data i godzina rozpoczęcia transportu</td>
								<td class="niewypelniane">Data i godzina zakończenia transportu</td>
								<td class="niewypelniane">Adres miejsca wysyłki</td>
								<td class="niewypelniane">Adres pośredni wysyłki</td>
								<td class="niewypelniane">Adres miejsca docelowego, do którego został zlecony transport</td>
							</tr>
							<tr>
								<td class="srodek" width="auto">
									<xsl:if test="tns:DataGodzRozpTransportu">
										<xsl:value-of select="tns:DataGodzRozpTransportu"/>
									</xsl:if>
								</td>
								<td class="srodek" width="auto">
									<xsl:if test="tns:DataGodzZakTransportu">
										<xsl:value-of select="tns:DataGodzZakTransportu"/>
									</xsl:if>
								</td>
								<td class="lewa" width="auto">
									<xsl:for-each select="tns:WysylkaZ">
										<xsl:text>Kod kraju: </xsl:text>
										<xsl:apply-templates select="tns:KodKraju"/>
										<xsl:text>; </xsl:text>
										<br/>
										<xsl:text>Adres: </xsl:text>
										<xsl:apply-templates select="tns:AdresL1"/>
										<xsl:if test="not(tns:AdresL2)">
											<xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="tns:AdresL2">
											<xsl:text> </xsl:text>
											<xsl:apply-templates select="tns:AdresL2"/>
											<xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="tns:GLN">
											<br/>
											<xsl:text>GLN: </xsl:text>
											<xsl:value-of select="tns:GLN"/>
											<xsl:text>; </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:for-each select="tns:WysylkaPrzez">
										<xsl:text>Kod kraju</xsl:text>
										<xsl:number value="position()" format=" (1) "/>:
										<xsl:apply-templates select="tns:KodKraju"/>
										<xsl:text>; </xsl:text>
										<br/>
										<xsl:text>Adres: </xsl:text>
										<xsl:apply-templates select="tns:AdresL1"/>
										<xsl:if test="not(tns:AdresL2)">
											<xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="tns:AdresL2">
											<xsl:text> </xsl:text>
											<xsl:apply-templates select="tns:AdresL2"/>
											<xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="tns:GLN">
											<br/>
											<xsl:text>GLN: </xsl:text>
											<xsl:value-of select="tns:GLN"/>
											<xsl:text>; </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</td>
								<td class="wypelniane" width="auto">
									<xsl:for-each select="tns:WysylkaDo">
										<xsl:text>Kod kraju: </xsl:text>
										<xsl:apply-templates select="tns:KodKraju"/>
										<xsl:text>; </xsl:text>
										<br/>
										<xsl:text>Adres: </xsl:text>
										<xsl:apply-templates select="tns:AdresL1"/>
										<xsl:if test="not(tns:AdresL2)">
											<xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="tns:AdresL2">
											<xsl:text> </xsl:text>
											<xsl:apply-templates select="tns:AdresL2"/>
											<xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="tns:GLN">
											<br/>
											<xsl:text>GLN: </xsl:text>
											<xsl:value-of select="tns:GLN"/>
											<xsl:text>; </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</table>
						<br/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="tns:PodmiotPosredniczacy = '1'">
					<div>Dostawa dokonana przez podmiot, o którym mowa w art. 22 ust. 2d ustawy (pole dotyczy przypadku, w którym podmiot uczestniczy w transakcji łańcuchowej innej niż procedura trójstronna uproszczona, o której mowa w art. 135 ust. 1 pkt 4 ustawy):
					<input type="checkbox" checked="checked" disabled="disabled"/>
						<b>1. Tak</b>
					</div>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<br/>
	</xsl:template>
	<xsl:template name="Zamowienie">
		<xsl:if test="tns:Fa/tns:Zamowienie">
			<b>Zamówienie</b>
			<br/>
			<br/>
			<xsl:for-each select="tns:Fa/tns:Zamowienie">
				<br/>
				<div>Wartość zamówienia lub umowy z uwzględnieniem kwoty podatku:
					<b>
						<xsl:value-of select="tns:WartoscZamowienia"/>
					</b>
				</div>
				<br/>
				<b>Szczegółowe pozycje zamówienia lub umowy w walucie, w której wystawiono fakturę zaliczkową</b>
				<br/>
				<br/>
				<br/>
				<table class="white-space">
					<tr>
						<td class="niewypelniane">Numer wiersza zamówienia lub umowy</td>
						<td class="niewypelniane">Uniwersalny unikalny numer wiersza zamówienia lub umowy</td>
						<td class="niewypelniane">Nazwa (rodzaj) towaru lub usługi</td>
						<td class="niewypelniane">Indeks</td>
						<td class="niewypelniane">Jednostka miary zamówionego towaru lub zakres usługi</td>
						<td class="niewypelniane">Ilość zamówionego towaru lub zakres usługi</td>
						<td class="niewypelniane">Cena jednostkowa netto</td>
						<td class="niewypelniane">Wartość sprzedaży netto zamówionego towaru lub zakres usługi</td>
						<td class="niewypelniane">Kwota VAT od zamówionego towaru lub usługi</td>
						<td class="niewypelniane">Stawka podatku</td>
						<td class="niewypelniane">Stawka podatku od wartości dodanej</td>
						<td class="niewypelniane">Klasyfikacja</td>
						<td class="niewypelniane">Kwota podatku akcyzowego zawarta w cenie towaru</td>
						<td class="niewypelniane">Oznaczenie dotyczące dostawy towarów i świadczenia usług lub procedury</td>
						<td class="niewypelniane">Znacznik dla towaru lub usługi z załącznika nr 15 do ustawy</td>
						<td class="niewypelniane">Znacznik stanu przed korektą</td>
					</tr>
					<xsl:for-each select="tns:ZamowienieWiersz">
						<tr>
							<td class="srodek" width="auto">
								<xsl:value-of select="tns:NrWierszaZam"/>
							</td>
							<td class="srodek" width="auto">
								<xsl:value-of select="tns:UU_IDZ"/>
							</td>
							<td class="lewa" width="auto">
								<xsl:value-of select="tns:P_7Z"/>
							</td>
							<td class="srodek" width="auto">
								<xsl:value-of select="tns:IndeksZ"/>
							</td>
							<td class="srodek" width="auto">
								<xsl:value-of select="tns:P_8AZ"/>
							</td>
							<td class="prawa" width="auto">
								<xsl:value-of select="tns:P_8BZ"/>
							</td>
							<td class="prawa" width="auto">
								<xsl:value-of select="tns:P_9AZ"/>
							</td>
							<td class="prawa" width="auto">
								<xsl:value-of select="tns:P_11NettoZ"/>
							</td>
							<td class="prawa" width="auto">
								<xsl:value-of select="tns:P_11VatZ"/>
							</td>
							<td class="srodek" width="auto">
								<xsl:choose>
									<xsl:when test="tns:P_12Z = '23'">
										<xsl:text>23%</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = '22'">
										<xsl:text>22%</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = '8'">
										<xsl:text>8%</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = '7'">
										<xsl:text>7%</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = '5'">
										<xsl:text>5%</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = '4'">
										<xsl:text>4%</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = '3'">
										<xsl:text>3%</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = '0'">
										<xsl:text>0%</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = 'zw'">
										<xsl:text>zw</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = 'oo'">
										<xsl:text>oo</xsl:text>
									</xsl:when>
									<xsl:when test="tns:P_12Z = 'np'">
										<xsl:text>np</xsl:text>
									</xsl:when>
								</xsl:choose>
							</td>
							<td class="srodek" width="auto">
								<xsl:if test="tns:P_12Z_XII">
									<xsl:value-of select="tns:P_12Z_XII"/>
									<xsl:text>%</xsl:text>
								</xsl:if>
							</td>
							<td class="lewa" width="auto">
								<xsl:if test="tns:GTINZ">
									GTIN:
									<xsl:value-of select="tns:GTINZ"/>;
								</xsl:if>
								<xsl:if test="tns:PKWiUZ">
									<xsl:if test="tns:GTINZ">
										<br/>
									</xsl:if>
									PKWiU:
									<xsl:value-of select="tns:PKWiUZ"/>;
								</xsl:if>
								<xsl:if test="tns:CNZ">
									<xsl:if test="tns:GTINZ|tns:PKWiUZ">
										<br/>
									</xsl:if>
									CN:
									<xsl:value-of select="tns:CNZ"/>;
								</xsl:if>
								<xsl:if test="tns:PKOBZ">
									<xsl:if test="tns:GTINZ|tns:PKWiUZ|tns:CNZ">
										<br/>
									</xsl:if>
									PKOB:
									<xsl:value-of select="tns:PKOBZ"/>;
								</xsl:if>
							</td>
							<td class="prawa" width="auto">
								<xsl:value-of select="tns:KwotaAkcyzyZ"/>
							</td>
							<td class="srodek" width="auto">
								<xsl:if test="tns:GTUZ">
									<xsl:value-of select="tns:GTUZ"/>
								</xsl:if>
								<xsl:if test="tns:ProceduraZ">
									<xsl:if test="tns:GTUZ">
										<br/>
									</xsl:if>
									<xsl:value-of select="tns:ProceduraZ"/>
								</xsl:if>
							</td>
							<td class="srodek">
								<xsl:if test="tns:P_12Z_Zal_15 = '1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									<b>
										<xsl:text>1. Tak</xsl:text>
									</b>
								</xsl:if>
							</td>
							<td class="srodek">
								<xsl:if test="tns:StanPrzedZ = '1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>
									<b>
										<xsl:text>1. Tak</xsl:text>
									</b>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PrzyczynaKorekty">
		<xsl:for-each select="tns:Fa">
			<xsl:if test="tns:PrzyczynaKorekty|tns:TypKorekty|tns:DaneFaKorygowanej|tns:OkresFaKorygowanej|tns:NrFaKorygowany|tns:Podmiot1K|tns:Podmiot2K">
				<b>Korekta</b>
				<br/>
				<br/>
				<xsl:if test="tns:PrzyczynaKorekty">
					<table class="break-word" width="100%">
						<tr>
							<td class="niewypelniane" width="25%">Przyczyna korekty dla faktur korygujących</td>
							<td class="wypelniane" width="75%">
								<xsl:value-of select="tns:PrzyczynaKorekty"/>
							</td>
						</tr>
					</table>
					<br/>
				</xsl:if>
				<xsl:if test="tns:TypKorekty">
					<table width="100%">
						<tr>
							<td class="niewypelniane" width="25%">Typ skutku korekty w ewidencji dla podatku od towarów i usług</td>
							<td class="wypelniane" width="75%">
								<xsl:choose>
									<xsl:when test="tns:TypKorekty = '1'">
										<xsl:text>Korekta skutkująca w dacie ujęcia faktury pierwotnej</xsl:text>
									</xsl:when>
									<xsl:when test="tns:TypKorekty = '2'">
										<xsl:text>Korekta skutkująca w dacie wystawienia faktury korygującej</xsl:text>
									</xsl:when>
									<xsl:when test="tns:TypKorekty = '3'">
										<xsl:text>Korekta skutkująca w dacie innej, w tym gdy dla różnych pozycji faktury korygującej daty te są różne</xsl:text>
									</xsl:when>
								</xsl:choose>
							</td>
						</tr>
					</table>
					<br/>
				</xsl:if>
				<xsl:if test="tns:DaneFaKorygowanej">
					<table class="break-word">
						<tr>
							<td class="niewypelniane" width="10%">Znacznik faktury korygowanej</td>
							<td class="niewypelniane" width="10%">Data wystawienia faktury korygowanej</td>
							<td class="niewypelniane" width="50%">Numer faktury korygowanej</td>
							<td class="niewypelniane" width="30%">Numer identyfikujący fakturę korygowaną w KSeF</td>
						</tr>
						<xsl:for-each select="tns:DaneFaKorygowanej">
							<tr>
								<td class="wypelniane" width="10%">
									<xsl:if test="tns:NrKSeF = '1'">
										<i>
											<xsl:text>KSeF</xsl:text>
										</i>
									</xsl:if>
									<xsl:if test="tns:NrKSeFN = '1'">
										<i>
											<xsl:text>poza KSeF</xsl:text>
										</i>
									</xsl:if>
								</td>
								<td class="srodek" width="10%">
									<xsl:value-of select="tns:DataWystFaKorygowanej"/>
								</td>
								<td class="wypelniane" width="50%">
									<xsl:value-of select="tns:NrFaKorygowanej"/>
								</td>
								<td class="wypelniane" width="30%">
									<xsl:value-of select="tns:NrKSeFFaKorygowanej"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
					<br/>
				</xsl:if>
				<xsl:if test="tns:OkresFaKorygowanej">
					<table class="break-word">
						<tr>
							<td class="niewypelniane" width="25%">Dla faktury korygującej, o której mowa w art. 106j ust. 3 ustawy - okres, do którego odnosi się udzielany opust lub udzielana obniżka, w przypadku gdy podatnik udziela opustu lub obniżki ceny w odniesieniu do dostaw towarów lub usług dokonanych lub świadczonych na rzecz jednego odbiorcy w danym okresie</td>
							<td class="wypelniane" width="75%">
								<xsl:value-of select="tns:OkresFaKorygowanej"/>
							</td>
						</tr>
					</table>
					<br/>
				</xsl:if>
				<xsl:if test="tns:NrFaKorygowany">
					<table class="break-word">
						<tr>
							<td class="niewypelniane" width="25%">Poprawny numer faktury korygowanej w przypadku, gdy przyczyną korekty jest błędny numer faktury korygowanej</td>
							<td class="wypelniane" width="75%">
								<xsl:value-of select="tns:NrFaKorygowany"/>
							</td>
						</tr>
					</table>
					<br/>
				</xsl:if>
				<xsl:if test="tns:Podmiot1K">
					<xsl:for-each select="tns:Podmiot1K">
						<table>
							<tr>
								<td class="niewypelniane">Dane sprzedawcy występujące w fakturze korygowanej</td>
							</tr>
						</table>
						<table class="break-word">
							<tr>
								<td class="niewypelniane" width="15%">Kod (prefiks) podatnika VAT UE</td>
								<td class="niewypelniane" width="15%">NIP</td>
								<td class="niewypelniane" width="70%">Imię i nazwisko lub nazwa</td>
							</tr>
							<tr>
								<td class="srodek" width="15%">
									<xsl:value-of select="tns:PrefiksPodatnika"/>
								</td>
								<xsl:for-each select="tns:DaneIdentyfikacyjne">
									<td class="srodek" width="15%">
										<xsl:value-of select="tns:NIP"/>
									</td>
									<td class="lewa" width="70%">
										<xsl:if test="tns:Nazwa">
											<xsl:value-of select="tns:Nazwa"/>
										</xsl:if>
									</td>
								</xsl:for-each>
							</tr>
						</table>
						<br/>
						<xsl:for-each select="tns:Adres">
							<table class="break-word">
								<tr>
									<td class="niewypelniane">Adres podatnika</td>
								</tr>
							</table>
							<table class="break-word">
								<tr>
									<td class="niewypelniane" width="10%">Kod kraju</td>
									<td class="niewypelniane" width="80%">Adres</td>
									<td class="niewypelniane" width="10%">GLN</td>
								</tr>
								<tr>
									<td class="srodek" style="width:10%">
										<xsl:apply-templates select="tns:KodKraju"/>
									</td>
									<td class="lewa" style="width:80%">
										<xsl:apply-templates select="tns:AdresL1"/>
										<xsl:if test="tns:AdresL2">
											<xsl:text> </xsl:text>
											<xsl:apply-templates select="tns:AdresL2"/>
										</xsl:if>
									</td>
									<td class="srodek" style="width:10%">
										<xsl:if test="tns:GLN">
											<xsl:value-of select="tns:GLN"/>
										</xsl:if>
									</td>
								</tr>
							</table>
							<br/>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="tns:Podmiot2K">
					<xsl:for-each select="tns:Podmiot2K">
						<table>
							<tr>
								<td class="niewypelniane" colspan="6">Dane nabywcy występujące na fakturze korygowanej <xsl:number value="position()" format=" (1) "/>
								</td>
							</tr>
						</table>
						<table class="break-word">
							<tr>
								<xsl:if test="tns:DaneIdentyfikacyjne/tns:NIP">
									<td class="niewypelniane" width="20%">NIP</td>
								</xsl:if>
								<xsl:if test="tns:DaneIdentyfikacyjne/tns:KodUE">
									<td class="niewypelniane" width="10%">Kod (prefiks) nabywcy VAT UE</td>
									<td class="niewypelniane" width="10%">Numer Identyfikacyjny VAT kontrahenta UE</td>
								</xsl:if>
								<xsl:if test="tns:DaneIdentyfikacyjne/tns:NrID">
									<td class="niewypelniane" width="20%">Kod kraju nadania  i identyfikator podatkowy inny</td>
								</xsl:if>
								<xsl:if test="tns:DaneIdentyfikacyjne/tns:BrakID">
									<td class="niewypelniane" width="20%">Podmiot nie posiada identyfikatora podatkowego lub identyfikator nie występuje na fakturze:</td>
								</xsl:if>
								<td class="niewypelniane" width="80%">Imię i nazwisko lub nazwa</td>
							</tr>
							<tr>
								<xsl:for-each select="tns:DaneIdentyfikacyjne">
									<xsl:if test="tns:NIP">
										<td class="srodek" width="20%">
											<xsl:value-of select="tns:NIP"/>
										</td>
									</xsl:if>
									<xsl:if test="tns:KodUE">
										<td class="srodek" width="10%">
											<xsl:value-of select="tns:KodUE"/>
										</td>
										<td class="srodek" width="10%">
											<xsl:value-of select="tns:NrVatUE"/>
										</td>
									</xsl:if>
									<xsl:if test="tns:NrID">
										<td class="srodek" width="20%">
											<xsl:apply-templates select="tns:KodKraju"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="tns:NrID"/>
										</td>
									</xsl:if>
									<xsl:if test="tns:BrakID = '1'">
										<td class="srodek" width="20%">
											<input type="checkbox" checked="checked" disabled="disabled"/>
											<b>
												<xsl:text>1. Tak</xsl:text>
											</b>
										</td>
									</xsl:if>
									<td class="lewa" width="80%">
										<xsl:if test="tns:Nazwa">
											<xsl:value-of select="tns:Nazwa"/>
										</xsl:if>
									</td>
								</xsl:for-each>
							</tr>
						</table>
						<br/>
						<xsl:for-each select="tns:Adres">
							<table class="break-word">
								<tr>
									<td class="niewypelniane">Adres nabywcy</td>
								</tr>
							</table>
							<table class="break-word">
								<tr>
									<td class="niewypelniane" width="10%">Kod kraju</td>
									<td class="niewypelniane" width="80%">Adres</td>
									<td class="niewypelniane" width="10%">GLN</td>
								</tr>
								<tr>
									<td class="srodek" style="width:10%">
										<xsl:apply-templates select="tns:KodKraju"/>
									</td>
									<td class="lewa" style="width:80%">
										<xsl:apply-templates select="tns:AdresL1"/>
										<xsl:if test="tns:AdresL2">
											<xsl:text> </xsl:text>
											<xsl:apply-templates select="tns:AdresL2"/>
										</xsl:if>
									</td>
									<td class="srodek" style="width:10%">
										<xsl:if test="tns:GLN">
											<xsl:value-of select="tns:GLN"/>
										</xsl:if>
									</td>
								</tr>
							</table>
							<br/>
						</xsl:for-each>
						<xsl:if test="tns:IDNabywcy">
							<div>
								Unikalny klucz powiązania danych nabywcy na fakturach korygujących, w przypadku gdy dane nabywcy na fakturze korygującej zmieniły się w stosunku do danych na fakturze korygowanej:
							<b>
									<xsl:value-of select="tns:IDNabywcy"/>
								</b>
							</div>
							<br/>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
			<xsl:if test="tns:P_15ZK">
				<div>
					W przypadku korekt faktur zaliczkowych - kwota zapłaty przed korektą. W przypadku korekt faktur, o których mowa w art. 106f ust. 3 ustawy - kwota pozostała do zapłaty przed korektą:
							<b>
						<xsl:value-of select="tns:P_15ZK"/>
					</b>
				</div>
				<br/>
			</xsl:if>
			<xsl:if test="tns:KursWalutyZK">
				<div>
					Kurs waluty stosowany do wyliczenia kwoty podatku w przypadkach, o których mowa w dziale VI ustawy przed korektą:
							<b>
						<xsl:value-of select="tns:KursWalutyZK"/>
					</b>
				</div>
				<br/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ZaliczkaCzesciowa">
		<xsl:if test="tns:Fa/tns:ZaliczkaCzesciowa">
			<table>
				<b>Zaliczka Częściowa</b>
				<br/>
			</table>
			<table class="break-word" width="60%">
				<tr>
					<td class="niewypelniane" colspan="3" width="60%">Dane dla przypadków faktur dokumentujących otrzymanie więcej niż jednej zaliczki oraz faktur rozliczeniowych dokumentujących jednocześnie otrzymanie części zapłaty przed dokonaniem czynności. W przypadku faktur rozliczeniowych różnica kwoty należności ogółem i sumy kwot wykazanych płatności stanowi kwotę pozostałą do zapłaty</td>
				</tr>
				<tr>
					<td class="niewypelniane" width="20%">Data otrzymania płatności, o której mowa w art. 106b ust. 1 pkt 4 ustawy</td>
					<td class="niewypelniane" width="20%">Kwota płatności, o której mowa w art. 106b ust. 1 pkt 4 ustawy, składająca się na kwotę ogółem. W przypadku faktur korygujących - korekta kwoty wynikającej z faktury korygowanej</td>
					<td class="niewypelniane" width="20%">Kurs waluty stosowany do wyliczenia kwoty podatku w przypadkach, o których mowa w dziale VI ustawy</td>
					<td>
						<table width="10%">
							<tbody>
								<tr>
									<td/>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
				<xsl:for-each select="tns:Fa/tns:ZaliczkaCzesciowa">
					<tr>
						<td class="prawa" width="20%">
							<xsl:value-of select="tns:P_6Z"/>
						</td>
						<td class="prawa" width="20%">
							<xsl:value-of select="tns:P_15Z"/>
						</td>
						<td class="prawa" width="20%">
							<xsl:value-of select="tns:KursWalutyZW"/>
						</td>
					</tr>
				</xsl:for-each>
			</table>
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DodatkowyOpis">
		<xsl:if test="tns:Fa/tns:DodatkowyOpis">
			<table>
				<b>Dodatkowy opis</b>
				<br/>
			</table>
			<br/>
			<table class="break-word" width="100%">
				<tr>
					<td class="niewypelniane" colspan="3">Pola przeznaczone dla wykazywania dodatkowych danych na fakturze, w tym wymaganych przepisami prawa, dla których nie przewidziano innych pól/elementów</td>
				</tr>
				<tr>
					<td class="niewypelniane" width="20%">Numer wiersza faktury lub zamówienia, jeśli informacja odnosi się wyłącznie do danej pozycji faktury</td>
					<td class="niewypelniane" width="20%">Klucz</td>
					<td class="niewypelniane" width="20%">Wartość</td>
				</tr>
				<xsl:for-each select="tns:Fa/tns:DodatkowyOpis">
					<tr>
						<td class="lewa" width="20%">
							<xsl:value-of select="tns:NrWiersza"/>
						</td>
						<td class="lewa" width="20%">
							<xsl:value-of select="tns:Klucz"/>
						</td>
						<td class="lewa" width="20%">
							<xsl:value-of select="tns:Wartosc"/>
						</td>
					</tr>
				</xsl:for-each>
			</table>
			<br/>
		</xsl:if>
		<br/>
		<xsl:if test="tns:Fa/tns:FakturaZaliczkowa">
			<table>
				<b>Faktury zaliczkowe</b>
				<br/>
			</table>
			<br/>
			<table class="break-word" width="100%">
				<tr>
					<td class="niewypelniane" colspan="3">Numery faktur zaliczkowych lub ich numery KSeF, jeśli zostały wystawione z użyciem KSeF</td>
				</tr>
				<tr>
					<td class="niewypelniane" width="4%">Znacznik faktury zaliczkowej wystawionej poza KSeF</td>
					<td class="niewypelniane" width="48%">Numer faktury zaliczkowej wystawionej poza KSeF</td>
					<td class="niewypelniane" width="48%">Numer faktury zaliczkowej wystawionej w KsEF</td>
				</tr>
				<xsl:for-each select="tns:Fa/tns:FakturaZaliczkowa">
					<tr>
						<xsl:if test="tns:NrKSeFZN = '1'">
							<td class="srodek" width="4%">
								<input type="checkbox" checked="checked" disabled="disabled"/>
								<b>
									<xsl:text>1. Tak</xsl:text>
								</b>
							</td>
							<td class="prawa" width="48%">
								<xsl:value-of select="tns:NrFaZaliczkowej"/>
							</td>
							<td class="niewypelniane" width="48%"/>
						</xsl:if>
						<xsl:if test="tns:NrKSeFFaZaliczkowej">
							<td class="niewypelniane" width="4%"/>
							<td class="niewypelniane" width="48%"/>
							<td class="prawa" width="48%">
								<xsl:value-of select="tns:NrKSeFFaZaliczkowej"/>
							</td>
						</xsl:if>
					</tr>
				</xsl:for-each>
			</table>
			<br/>
		</xsl:if>
		<br/>
		<xsl:if test="tns:Fa/tns:ZwrotAkcyzy = '1'">
			<div>
				Zwrot akcyzy:
				<b>
					<input type="checkbox" checked="checked" disabled="disabled"/>
						1. Tak
				</b>
			</div>
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="WZ">
		<xsl:if test="tns:Fa/tns:WZ">
			<table>
				<tr>
					<td>
						<b>Numery dokumentów magazynowych WZ (wydanie na zewnątrz) związane z fakturą</b>
					</td>
				</tr>
			</table>
			<br/>
			<table class="break-word">
				<tr>
					<td class="niewypelniane" width="5%">Lp.</td>
					<td class="niewypelniane" width="95%">Numer WZ</td>
				</tr>
				<xsl:for-each select="tns:Fa/tns:WZ">
					<tr>
						<td class="niewypelniane" width="5%">
							<xsl:number value="position()" format="1. "/>
						</td>
						<td class="wypelniane" width="95%">
							<xsl:value-of select="."/>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:if>
		<br/>
	</xsl:template>
	<xsl:template name="Stopka">
		<xsl:if test="tns:Stopka">
			<div>
				<b>Pozostałe dane na fakturze</b>
			</div>
			<br/>
			<xsl:for-each select="tns:Stopka/tns:Informacje">
				<table class="break-word">
					<tr>
						<td>
							<xsl:number value="position()" format="1. "/>
							<xsl:value-of select="tns:StopkaFaktury"/>
							<xsl:text>;</xsl:text>
						</td>
					</tr>
				</table>
				<br/>
			</xsl:for-each>
			<div>
				<b>Numery podmiotu lub grupy podmiotów w innych rejestrach i bazach danych</b>
			</div>
			<br/>
			<xsl:for-each select="tns:Stopka/tns:Rejestry">
				<table class="break-word">
					<tr>
						<td class="niewypelniane" colspan="2">
							<xsl:number value="position()" format=" (1) "/>
							<xsl:value-of select="tns:PelnaNazwa"/>
						</td>
					</tr>
				</table>
				<table class="break-word">
					<tr>
						<td class="niewypelniane" width="10%">KRS</td>
						<td class="wypelniane" width="90%">
							<xsl:value-of select="tns:KRS"/>
						</td>
					</tr>
					<tr>
						<td class="niewypelniane" width="10%">REGON</td>
						<td class="wypelniane" width="90%">
							<xsl:value-of select="tns:REGON"/>
						</td>
					</tr>
					<tr>
						<td class="niewypelniane" width="10%">BDO</td>
						<td class="wypelniane" width="90%">
							<xsl:value-of select="tns:BDO"/>
						</td>
					</tr>
				</table>
				<br/>
			</xsl:for-each>
			<br/>
			<div align="center">
				<a href="https://www.gov.pl/web/kas/krajowy-system-e-faktur">
					<b>Krajowy System <font style="color:red">e</font>-Faktur</b>
				</a>
			</div>
			<br/>
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Zalacznik">
		<xsl:if test="tns:Zalacznik">
			<xsl:for-each select="tns:Zalacznik/tns:BlokDanych">
				<br/>
				<br/>
				<div>
					<b>Szczegółowe dane załącznika <xsl:number value="position()" format=" (1) "/></b>
				</div>
				<br/>
				<div>
					Nagłówek bloku danych: <b>
						<xsl:value-of select="tns:ZNaglowek"/>
					</b>
				</div>
				<br/>
				<table class="break-word" width="100%">
					<tr>
						<td class="niewypelniane" width="50%">Klucz</td>
						<td class="niewypelniane" width="50%">Wartość</td>
					</tr>
					<xsl:for-each select="tns:MetaDane">
						<tr>
							<td class="lewa" width="50%">
								<xsl:value-of select="tns:ZKlucz"/>
							</td>
							<td class="lewa" width="50%">
								<xsl:value-of select="tns:ZWartosc"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
				<br/>
				<xsl:for-each select="tns:Tekst/tns:Akapit">
					<div>
						 Opis <xsl:number value="position()" format=" (1) "/>: <xsl:value-of select="."/>
					</div>
				</xsl:for-each>
				<br/>
				<div>
					Tabela
				</div>
				<br/>
				<xsl:for-each select="tns:Tabela">
					<table class="break-word" width="100%">
						<xsl:if test="tns:Opis">
							<div>
								<b>
									<xsl:value-of select="tns:Opis"/>
								</b>
							</div>
							<br/>
						</xsl:if>
						<tr>
							<td class="niewypelniane" width="50%">Klucz</td>
							<td class="niewypelniane" width="50%">Wartość</td>
						</tr>
						<xsl:for-each select="tns:TMetaDane">
							<tr>
								<td class="lewa" width="50%">
									<xsl:value-of select="tns:TKlucz"/>
								</td>
								<td class="lewa" width="50%">
									<xsl:value-of select="tns:TWartosc"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
					<br/>
					<table class="break-word" width="100%">
						<tr>
							<xsl:for-each select="tns:TNaglowek/tns:Kol">
								<td class="niewypelniane" width="auto">
									<xsl:value-of select="tns:NKom"/>
								</td>
							</xsl:for-each>
						</tr>
						<xsl:for-each select="tns:Wiersz">
							<tr>
								<xsl:for-each select="tns:WKom">
									<td class="lewa" width="auto">
										<xsl:value-of select="."/>
									</td>
								</xsl:for-each>
							</tr>
						</xsl:for-each>
					</table>
					<br/>
					<table class="break-word" width="100%">
						<tr>
							<td class="niewypelniane" colspan="20">Podsumowania tabeli</td>
						</tr>
						<xsl:for-each select="tns:Suma">
							<tr>
								<xsl:for-each select="tns:SKom">
									<td class="lewa" width="auto">
										<xsl:value-of select="."/>
									</td>
								</xsl:for-each>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NaglowekTytulowyZalacznik">
		<xsl:param name="naglowek"/>
		<xsl:param name="nazwa"/>
		<xsl:param name="podstawy-prawne"/>
		<xsl:param name="uzycie"/>
		<div>
			<xsl:choose>
				<xsl:when test="$uzycie = 'deklaracja'">
					<xsl:attribute name="class">tlo-formularza</xsl:attribute>
				</xsl:when>
				<xsl:when test="$uzycie = 'zalacznik'">
					<xsl:attribute name="class">tlo-zalacznika</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="$nazwa">
				<h1 class="nazwa">
					<xsl:copy-of select="$nazwa"/>
				</h1>
			</xsl:if>
		</div>
		<xsl:if test="$podstawy-prawne">
			<div class="prawne">
				<xsl:copy-of select="$podstawy-prawne"/>
			</div>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
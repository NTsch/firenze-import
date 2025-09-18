<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cei="http://www.monasterium.net/NS/cei"
    xmlns:ead="http://ead3.archivists.org/schema/"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:icar-import="http://www.san.beniculturali.it/icar-import"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:strip-space elements="*" />
    
    <xsl:template match="*|@*">
        <xsl:message>WARNING: Unprocessed node: <xsl:value-of select="name()"/></xsl:message>
    </xsl:template>
    
    <!--<xsl:variable name="img-file" select="doc('img_list_stutzmann.xml')"/>-->
    
    <!--TODO: icar-import-Elemente - was brauch ich daraus?-->
    
    <xsl:template match='icar-import:*'>
        <xsl:apply-templates select="//ead:ead"/>
    </xsl:template>
    
    <xsl:template match='ead:ead'>
        <cei:cei>
            <xsl:apply-templates/>
        </cei:cei>
    </xsl:template>
    
    <xsl:template match='ead:eadheader'>
        <cei:teiHeader>
            <xsl:apply-templates/>
        </cei:teiHeader>
    </xsl:template>
    
    <xsl:template match='ead:eadid'/>
    
    <xsl:template match='ead:filedesc'>
        <cei:fileDesc>
            <xsl:apply-templates/>
        </cei:fileDesc>
    </xsl:template>
    
    <xsl:template match='ead:titlestmt'>
        <cei:titleStmt>
            <xsl:apply-templates/>
        </cei:titleStmt>
    </xsl:template>
    
    <xsl:template match="ead:titleproper">
        <cei:title>
            <xsl:apply-templates/>
        </cei:title>
    </xsl:template>
    
    <xsl:template match="ead:subtitle">
        <cei:p>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="ead:publicationstmt">
        <cei:publicationStmt>
            <xsl:apply-templates/>
        </cei:publicationStmt>
    </xsl:template>
    
    <xsl:template match="ead:publisher">
        <cei:publisher>
            <xsl:apply-templates/>
        </cei:publisher>
    </xsl:template>
    
    <xsl:template match="ead:address">
        <cei:pubPlace>
            <xsl:apply-templates/>
        </cei:pubPlace>
    </xsl:template>
    
    <xsl:template match="ead:addressline">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:quantity">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--TODO-->
    
    <!--###########################-->
    
    <xsl:template match="ead:control"/>
    
    <xsl:template match="ead:maintenancestatus"/>
    
    <xsl:template match="ead:maintenanceagency"/>
    
    <xsl:template match="ead:profiledesc"/>
    
    <xsl:template match="ead:physfacet"/>
    
    <xsl:template match="ead:bioghist"/>
    
    <!--###########################-->
    
    <xsl:template match="ead:odd">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:archdesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:archdesc[@level='fonds']">
        <cei:text>
            <cei:group>
                <xsl:apply-templates/>
            </cei:group>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="ead:did[parent::ead:archdesc or parent::ead:c[not(@level='file')]]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--<xsl:template match="ead:physdescstructured[@physdescstructuredtype='materialtype']">
        <cei:material>
            <xsl:apply-templates/>
        </cei:material>
    </xsl:template>-->
    
    <xsl:template match="ead:physdesc | ead:physdescstructured"/>
    
    <xsl:template match="ead:physdesc | ead:physdescstructured" mode="move">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:physdescstructured[@physdescstructuredtype='spaceoccupied']" mode='unify'>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:physdescstructured[@physdescstructuredtype='materialtype']" mode='unify'/>
    
    <xsl:template match="ead:dsc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:c[not(@level)]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:c[@level='item']">
        <xsl:variable name="icar_ud" select="substring-after(ead:did/ead:unitid[@localtype='metaFAD']/text(), 'ICAR UD ')"/>
        <cei:text type='charter'>
            <cei:front/>
            <cei:body>
                <cei:idno>
                    <xsl:value-of select="ead:did/ead:unitid[@localtype='metaFAD']"/>
                </cei:idno>
                <cei:chDesc>
                    <!--<xsl:apply-templates/>-->
                    <cei:issued>
                        <xsl:apply-templates select="ead:controlaccess/ead:geogname[@localtype='actum']"/>
                        <xsl:apply-templates select="ead:did/ead:unitdate | ead:did/ead:unitdatestructured" mode='unify'/>
                    </cei:issued>
                    <cei:witnessOrig>
                        <xsl:apply-templates select="ead:did/ead:daoset" mode="move"/>
                        <cei:archIdentifier>
                            <cei:arch>ASFI</cei:arch>
                            <cei:archFond>Diplomatico / Normali / Società Colombaria</cei:archFond>
                            <cei:idno>
                                <xsl:value-of select="concat('Numero di codice: ', ead:did/ead:unitid[@label='barcode']/text())"/>
                            </cei:idno>
                            <!--https://archiviodigitale-icar.cultura.gov.it/it/185/ricerca/detail/7651-->
                            <cei:ref target="{concat('https://archiviodigitale-icar.cultura.gov.it/it/185/ricerca/detail/', $icar_ud)}"></cei:ref>
                        </cei:archIdentifier>
                        <cei:physicalDesc>
                            <xsl:apply-templates select="ead:controlaccess/ead:genreform"/>
                            <xsl:apply-templates select="ead:did/ead:physdesc | ead:did/ead:physdescstructured" mode='unify'/>
                        </cei:physicalDesc>
                    </cei:witnessOrig>
                </cei:chDesc>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="ead:unitid">
        <cei:idno>
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template match="ead:unitid[@localtype='metaFAD']"/>
    
    <!--<xsl:template match="ead:unitid[@localtype='metaFAD']" mode='moved'>
        <cei:idno>
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>-->
    
    <xsl:template match="ead:unitid[@label='numeroOrdinamento']"/>
    
    <xsl:template match="ead:unitid[@label='barcode']"/>
    
    <xsl:template match="ead:unitid[@label='segnaturaAntica']"/>
    
    <xsl:template match="ead:unittitle">
        <cei:h1>
            <xsl:apply-templates/>
        </cei:h1>
    </xsl:template>
    
    <xsl:template match="ead:unittitle[ancestor::ead:c[@level/data()='item']]"/>
    
    <xsl:template match="ead:scopecontent">
        <cei:abstract>
            <xsl:apply-templates select=".//text()"/>
        </cei:abstract>
    </xsl:template>
    
    <xsl:template match="ead:daoset"/>
    
    <xsl:template match="ead:daoset" mode="move">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--<xsl:template match="ead:dao"/>-->
    
    <xsl:template match="ead:dao">
        <cei:figure>
            <cei:graphic url='{concat("https://archiviodigitale-icar.cultura.gov.it/iiif/diplomatico-firenze@get@", @identifier/data(), "@original/full/full/0/default.jpg")}'/>
        </cei:figure>
    </xsl:template>
    
    <xsl:template match="ead:p">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:head"/>
    
    <xsl:template match="ead:repository">
        <cei:archIdentifier>
            <cei:arch>
                <xsl:apply-templates/>
            </cei:arch>
        </cei:archIdentifier>
    </xsl:template>
    
    <xsl:template match="ead:bibliography">
        <cei:listBibl>
            <xsl:apply-templates/>
        </cei:listBibl>
    </xsl:template>
    
    <xsl:template match="ead:p[parent::ead:bibliography]">
        <cei:bibl>
            <xsl:apply-templates/>
        </cei:bibl>
    </xsl:template>
    
    <xsl:template match="ead:lb">
        <cei:lb>
            <xsl:apply-templates/>
        </cei:lb>
    </xsl:template>
    
    <xsl:template match="ead:controlaccess"/>
    
    <xsl:template match="ead:genreform">
        <cei:material>
            <xsl:apply-templates/>
        </cei:material>
    </xsl:template>
    
    <xsl:template match="ead:geogname[@localtype='actum']">
        <cei:placename>
            <xsl:apply-templates/>
        </cei:placename>
    </xsl:template>
    
    <xsl:template match="ead:part">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:accessrestrict"/>
    
    <xsl:template match="ead:emph"/>
    
    <xsl:template match="ead:unitdate">
        <xsl:choose>
            <xsl:when test="contains(./@normal/data(), '/')">
                <cei:dateRange from="{concat(substring-before(./@normal/data(), '/'), '9999')}" to="{concat(substring-after(./@normal/data(), '/'), '9999')}">
                    <xsl:apply-templates/>
                </cei:dateRange>
            </xsl:when>
            <xsl:when test="matches(./@normal/data(), '^\d{4}$')">
                <cei:date value="{concat(./@normal/data(), '9999')}">
                    <xsl:apply-templates/>
                </cei:date>
            </xsl:when>
            <xsl:otherwise>
                <cei:date value='99999999'>
                    <xsl:apply-templates/>
                </cei:date>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ead:unitdatestructured">
       <!--TODO!!-->
    </xsl:template>
    
    <xsl:template match="ead:dateset">
        <cei:date value='{replace(ead:datesingle/@standarddate/data(), "-", "")}'>
            <xsl:apply-templates select='ead:datesingle[@localtype]/text()'/>
        </cei:date>
    </xsl:template>
    
    <xsl:template match="ead:datesingle"/>

    <xsl:template match="ead:daterange">
        <cei:dateRange>
            <xsl:attribute name="from" select="ead:fromdate/@standarddate/data()"/>
            <xsl:attribute name="to" select="ead:todate/@standarddate/data()"/>
            <xsl:value-of select="concat(ead:fromdate, ' - ', ead:todate)"/>
        </cei:dateRange>
    </xsl:template>
    
    <xsl:template match="ead:fromdate">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:todate">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead:dimensions" mode="unify">
        <cei:dimensions>
            <xsl:apply-templates/>
        </cei:dimensions>
    </xsl:template>
    
    <!--######################-->
    
    <!--<xsl:template match="ead:c[@level='file']">
        <xsl:variable name="desc_id" select="did" />
        <xsl:choose>
            <!-\-scopecontent/p/text() is not always present-\->
            <xsl:when test="scopecontent/p/normalize-space()">
                
                <xsl:variable name="abstract-content"
                    select="string-join(
                    for $n in scopecontent/p/node() return (
                        if ($n/self::note) then concat('[', string-join($n//text(), ' '), ']')
                        else normalize-space(string($n))
                    ), ' ')" />
                    
                <xsl:for-each select="tokenize($abstract-content, ';')">
                    <xsl:call-template name="charter-content">
                        <xsl:with-param name="abstract-token">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.)">
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$desc_id/unittitle/text()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="desc_id" select="$desc_id"/>
                        <xsl:with-param name="counter" select="position()"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="charter-content">
                    <xsl:with-param name="abstract-token" select="did/unittitle/text()"></xsl:with-param>
                    <xsl:with-param name="desc_id" select="$desc_id"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="charter-content">
        <xsl:param name="abstract-token"/>
        <xsl:param name="desc_id"/>
        <xsl:param name="counter"/>
        <cei:text type="charter">
            <!-\-<cei:front>
                <xsl:apply-templates select="$desc_id/unittitle"/>
            </cei:front>-\->
            <cei:body>
                <cei:idno>
                    <xsl:choose>
                        <xsl:when test="$counter">
                            <xsl:variable name="id" select="concat($desc_id/unitid, '-', $counter)"/>
                            <xsl:attribute name="id" select="$id"/>
                            <xsl:value-of select="$id"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id" select="$desc_id/unitid"/>
                            <xsl:value-of select="$desc_id/unitid"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </cei:idno>
                <cei:chDesc>
                    <cei:abstract>
                        <xsl:apply-templates select="$abstract-token"/>
                    </cei:abstract>
                    <cei:witnessOrig>
                        <xsl:for-each select="$img-file//dossier[matches(@id, concat('ADCO ', replace($desc_id/unitid/text(), ' ', ''), '(-\d+)?$'))]/recto">
                            <cei:figure>
                                <cei:graphic url="{concat('https://images.monasterium.net/img/Quincy/ADCO_', replace($desc_id/unitid/text(), ' ', ''), '/', ./text())}"/>
                            </cei:figure>
                        </xsl:for-each>
                        <cei:archIdentifier>
                            <cei:archFond>17 H. – Abbaye de Quincy</cei:archFond>
                            <cei:arch>Archives départementales de la Côte-d'Or</cei:arch>
                            <cei:settlement>Dijon</cei:settlement>
                            <cei:country>France</cei:country>
                            <xsl:variable name="tt" select="$desc_id/parent::c/parent::c/@id/data()"/>
                            <cei:ref target='{concat("https://archives.cotedor.fr/console/ir_ead_visu.php?eadid=FRAD021_000002216&amp;cid=", $tt)}'/>
                        </cei:archIdentifier>
                    </cei:witnessOrig>
                    <xsl:apply-templates select="$desc_id/unitdate"/>
                    <cei:diplomaticAnalysis>
                        <xsl:apply-templates select="$desc_id/parent::c//bibliography"/>
                        <xsl:apply-templates select="$desc_id/parent::c//odd"/>
                    </cei:diplomaticAnalysis>
                </cei:chDesc>
            </cei:body>
        </cei:text>
    </xsl:template>-->
    
</xsl:stylesheet>


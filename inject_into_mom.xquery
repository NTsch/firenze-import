xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare namespace xrx = "http://www.monasterium.net/NS/xrx";
declare namespace eag = "http://www.archivgut-online.de/eag";
declare namespace ead = "urn:isbn:1-931666-22-9";

let $archive := collection('/db/mom-data/metadata.charter.public/IT-ASFi/DNAccademiaColombaria')
for $test-charter in doc('/db/niklas/import/firenze/output.xml')//cei:text[@type='charter']
let $barcode := substring-after($test-charter//cei:archIdentifier/cei:idno, 'Numero di codice: ')
for $db-charter in $archive/atom:entry
where $db-charter//cei:idno/text() = $barcode
where empty($db-charter//cei:witnessOrig/cei:figure)
return update insert $test-charter//cei:witnessOrig/cei:figure into $db-charter//cei:witnessOrig
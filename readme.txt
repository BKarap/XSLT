Стиль xml2SVGinHTML.xsl работает на xml-данных, которые содержат две группы элементов:
1. //TotalCategory, с поделементами Total (число) и category (легенда).  
2. //TotalSeverity, с поделементами Total (число) и severity (легенда).
Если легенды из стандарта CAP (по-английски) - они переводиятя на русский.
Результат запуска, например, saxona:
java -jar <PATH_TO_SAXSON_JAR>/saxon.jar -o res.htm data.xml xml2SVGinHTML.xsl
html-файл с 2-х колоночной таблицей, в каждой из колонок SVG-графики.

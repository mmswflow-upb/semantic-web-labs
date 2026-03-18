<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Sorted Movies</title>
                <style type="text/css">
                    body { font-family: \"Verdana\", sans-serif; background: #fafbff; color: #1b1f3b; }
                    table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
                    th, td { border: 1px solid #b7bcc7; padding: .5rem; }
                    th { background: #dfe4f5; }
                    caption { font-size: 1.2rem; margin-bottom: .5rem; font-weight: bold; }
                </style>
            </head>
            <body>
                <table>
                    <caption>Movies Sorted by Title</caption>
                    <tr>
                        <th>Title</th>
                        <th>Director</th>
                        <th>Year</th>
                        <th>Genre</th>
                    </tr>
                    <xsl:for-each select="movies/movie">
                        <xsl:sort select="title"/>
                        <tr>
                            <td><xsl:value-of select="title"/></td>
                            <td><xsl:value-of select="director"/></td>
                            <td><xsl:value-of select="year"/></td>
                            <td><xsl:value-of select="genre"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

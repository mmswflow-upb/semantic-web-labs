<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Titanic Schedule</title>
                <style type="text/css">
                    body { font-family: \"Palatino\", Georgia, serif; background: #0d1b2a; color: #f0f4ff; padding: 1rem; }
                    h1 { margin-top: 0; }
                    table { border-collapse: collapse; width: 100%; margin-top: 1rem; }
                    th, td { border: 1px solid #415b76; padding: .6rem; }
                    th { background: #1f3552; }
                    td { background: #12203d; text-align: center; }
                    .hall-info { text-align: left; font-weight: 600; }
                </style>
            </head>
            <body>
                <h1>Schedule for Titanic</h1>
                <xsl:variable name="titanic" select="movies/movie[title='Titanic']"/>
                <xsl:if test="$titanic">
                    <table border="1">
                        <tr>
                            <th>Hall</th>
                            <xsl:for-each select="$titanic/schedules/schedule">
                                <th>
                                    <xsl:value-of select="concat(day, ' (', date, ')')"/>
                                </th>
                            </xsl:for-each>
                        </tr>
                        <tr>
                            <td class="hall-info">
                                <xsl:for-each select="$titanic/halls/hall">
                                    <div>Hall <xsl:value-of select="@id"/> — <xsl:value-of select="chairType"/>, capacity <xsl:value-of select="capacity"/></div>
                                </xsl:for-each>
                            </td>
                            <xsl:for-each select="$titanic/schedules/schedule">
                                <td><xsl:value-of select="hours"/></td>
                            </xsl:for-each>
                        </tr>
                    </table>
                </xsl:if>
                <xsl:if test="not($titanic)">
                    <p>Movie &quot;Titanic&quot; not found in the provided XML.</p>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

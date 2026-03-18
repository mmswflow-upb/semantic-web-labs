<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Cinema Schedule</title>
                <style type="text/css">
                    body { font-family: \"Trebuchet MS\", Arial, sans-serif; background: #f4f5fb; }
                    .page { max-width: 900px; margin: 0 auto; padding: 2rem; }
                    .movie-card { background: white; border-radius: 8px; margin-bottom: 1.5rem; padding: 1rem 1.5rem; box-shadow: 0 4px 12px rgba(0,0,0,.08); }
                    .movie-card h2 { margin-top: 0; color: #1f3c88; }
                    .metadata { font-size: .95rem; color: #555; margin-bottom: .5rem; }
                    .section-title { font-weight: 600; margin: .75rem 0 .25rem; }
                    table { border-collapse: collapse; width: 100%; }
                    th, td { border: 1px solid #ccc; padding: .35rem .6rem; text-align: left; }
                    th { background: #e5e7f0; }
                </style>
            </head>
            <body>
                <div class="page">
                    <h1>Booked Movies</h1>
                    <p class="metadata">Generated from <strong>ex1.xml</strong> via the XSL transformation.</p>
                    <xsl:for-each select="movies/movie">
                        <div class="movie-card">
                            <h2><xsl:value-of select="title"/></h2>
                            <p class="metadata">
                                Director: <xsl:value-of select="director"/> |
                                Year: <xsl:value-of select="year"/> |
                                Genre: <xsl:value-of select="genre"/>
                            </p>
                            <div>
                                <span class="section-title">Actors</span>
                                <ul>
                                    <xsl:for-each select="actors/actor">
                                        <li><xsl:value-of select="name"/></li>
                                    </xsl:for-each>
                                </ul>
                            </div>
                            <xsl:if test="synopsis">
                                <div>
                                    <span class="section-title">Synopsis</span>
                                    <p><xsl:value-of select="synopsis"/></p>
                                </div>
                            </xsl:if>
                            <div>
                                <span class="section-title">Halls</span>
                                <table>
                                    <tr>
                                        <th>ID</th>
                                        <th>Chair Type</th>
                                        <th>Capacity</th>
                                    </tr>
                                    <xsl:for-each select="halls/hall">
                                        <tr>
                                            <td><xsl:value-of select="@id"/></td>
                                            <td><xsl:value-of select="chairType"/></td>
                                            <td><xsl:value-of select="capacity"/></td>
                                        </tr>
                                    </xsl:for-each>
                                </table>
                            </div>
                            <div>
                                <span class="section-title">Schedules</span>
                                <table>
                                    <tr>
                                        <th>Date</th>
                                        <th>Hours</th>
                                    </tr>
                                    <xsl:for-each select="schedules/schedule">
                                        <tr>
                                            <td><xsl:value-of select="date"/></td>
                                            <td><xsl:value-of select="hours"/></td>
                                        </tr>
                                    </xsl:for-each>
                                </table>
                            </div>
                        </div>
                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

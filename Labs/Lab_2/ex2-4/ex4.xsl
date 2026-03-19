<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Interstellar Schedule</title>
            </head>
            <body>
                <h1>Interstellar Schedule</h1>

                <table border="1">
                    <tr>
                        <th>Hour / Hall</th>
                        <th>Monday</th>
                        <th>Tuesday</th>
                        <th>Wednesday</th>
                        <th>Thursday</th>
                        <th>Friday</th>
                        <th>Saturday</th>
                        <th>Sunday</th>
                    </tr>

                    <tr>
                        <td>Program</td>

                        <td>
                            <xsl:for-each select="movies/movie[title='Interstellar']/schedules/schedule[day='Monday']">
                                <xsl:value-of select="hours"/>
                                <br/>
                                <xsl:for-each select="../../halls/hall">
                                    Hall <xsl:value-of select="@id"/>
                                    <br/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </td>

                        <td>
                            <xsl:for-each select="movies/movie[title='Interstellar']/schedules/schedule[day='Tuesday']">
                                <xsl:value-of select="hours"/>
                                <br/>
                                <xsl:for-each select="../../halls/hall">
                                    Hall <xsl:value-of select="@id"/>
                                    <br/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </td>

                        <td>
                            <xsl:for-each select="movies/movie[title='Interstellar']/schedules/schedule[day='Wednesday']">
                                <xsl:value-of select="hours"/>
                                <br/>
                                <xsl:for-each select="../../halls/hall">
                                    Hall <xsl:value-of select="@id"/>
                                    <br/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </td>

                        <td>
                            <xsl:for-each select="movies/movie[title='Interstellar']/schedules/schedule[day='Thursday']">
                                <xsl:value-of select="hours"/>
                                <br/>
                                <xsl:for-each select="../../halls/hall">
                                    Hall <xsl:value-of select="@id"/>
                                    <br/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </td>

                        <td>
                            <xsl:for-each select="movies/movie[title='Interstellar']/schedules/schedule[day='Friday']">
                                <xsl:value-of select="hours"/>
                                <br/>
                                <xsl:for-each select="../../halls/hall">
                                    Hall <xsl:value-of select="@id"/>
                                    <br/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </td>

                        <td>
                            <xsl:for-each select="movies/movie[title='Interstellar']/schedules/schedule[day='Saturday']">
                                <xsl:value-of select="hours"/>
                                <br/>
                                <xsl:for-each select="../../halls/hall">
                                    Hall <xsl:value-of select="@id"/>
                                    <br/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </td>

                        <td>
                            <xsl:for-each select="movies/movie[title='Interstellar']/schedules/schedule[day='Sunday']">
                                <xsl:value-of select="hours"/>
                                <br/>
                                <xsl:for-each select="../../halls/hall">
                                    Hall <xsl:value-of select="@id"/>
                                    <br/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>

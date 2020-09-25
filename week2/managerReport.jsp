<%-- 
    Document   : managerReport
    Created on : Jul 31, 2018, 5:19:06 PM
    Author     : gurkan.gezgen
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="biznet" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
    <head>
        <c:set var="context" value="${pageContext.request.contextPath}" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><spring:message code="managerReport.title"/></title>
    </head>
    <body>
        <script type="text/javascript">
            document.title = "<spring:message code="managerReport.title"/> - BIZZY";
            /*amCharts4 grafik değişkenleri*/
            var riskyVulgraph, topkbgraph, assetScoregraph, openVulgraph, topIpgraph, closedVulAssigneegraph;
            var riskyVulIndicator, topkbIndicator, assetScoreIndicator, topIpIndicator, openVulIndicator, closedVulAssigneeIndicator;
            var chartdiv;
            var table;
            var dayDifference = <c:out value = "${tendency.today - tendency.yesterday}"/>;
            var weekDifference = <c:out value = "${tendency.today - tendency.lastWeek}"/>;
            var monthDifference = <c:out value = "${tendency.today - tendency.lastMonth}"/>;
            if (dayDifference > 0) {
                dayDifference = "+" + dayDifference;
            }
            if (weekDifference > 0) {
                weekDifference = "+" + weekDifference;
            }
            if (monthDifference > 0) {
                monthDifference = "+" + monthDifference;
            }
            var colorSet = new am4core.ColorSet();
            colorSet.list = ["#cacaca", "#456173", "#1b3c59", "#e6b31e", "#e23e57", "#f95959", "#f73859", "#f1d18a", "#e6b31e", "#f1e58a"].map(function (color) {
                return new am4core.color(color);
            });
            var colorList = [
                am4core.color("#cacaca"),
                am4core.color("#456173"),
                am4core.color("#1b3c59"),
                am4core.color("#e6b31e"),
                am4core.color("#f95959"),
                am4core.color("#f73859"),
                am4core.color("#f1d18a"),
                am4core.color("#e6b31e"),
                am4core.color("#f1e58a")
            ];
            function loadRiskReportTable() {
                table = $('#riskReportTable').dataTable({
                    "aoColumnDefs": [{"bSortable": false, "aTargets": [0]}],
                    "searching": false,
                    "bLengthChange": false,
                    "bPaginate": false,
                    "bInfo": false,
                    "scrollX": true,
                    "order": [],
                    "columns": [
                        {"data": function (data, type, dataToSet) {
                                return '<div style ="font-size:15px;">' + data.category + '</div>';
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                return '<div style ="color:' + data.color + ';font-size:20px;text-shadow: 1px 1px 1px #000000"><b>' + data.grade + '</b></div>';
                            },
                            "searchable": false,
                            "orderable": false
                        }
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadRiskReport.json",
                        "data": function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                                obj[key] = tempObj[key];
                            });
                        },
                        "dataSrc": function (json) {   
                            if (json.data.length > 0) {
                                document.getElementById("totalGrade").innerHTML = '<div class="widget-thumb-body-stat longTextWrap" style="text-align: center; position: relative; text-shadow: 3px 3px 3px #000000; font-size: 60px; margin-bottom: 5px; color:' + json.data[0].totalColor + '"><b>' + json.data[0].totalGrade + '</b></div>';
                                var totalGradeCircle = document.querySelector("#totalGrade .longTextWrap");
                                var image = document.createElement("img");
                                if(decodeHtml(json.data[0].totalGrade) === "A+"){
                                    image.src = "${context}/resources/logo/riskGrade.png";
                                } else if(json.data[0].totalGrade === "A"){
                                    image.src = "${context}/resources/logo/riskGradeA.png";
                                } else if(json.data[0].totalGrade === "B"){
                                    image.src = "${context}/resources/logo/riskGradeB.png";
                                } else if(json.data[0].totalGrade === "C"){
                                    image.src = "${context}/resources/logo/riskGradeC.png";
                                } else if(json.data[0].totalGrade=== "D"){
                                    image.src = "${context}/resources/logo/riskGradeD.png";
                                } else if(json.data[0].totalGrade === "E"){
                                    image.src = "${context}/resources/logo/riskGradeE.png";
                                } else if(json.data[0].totalGrade === "F"){
                                    image.src = "${context}/resources/logo/riskGradeF.png";
                                } else {
                                    image.src = "${context}/resources/logo/newRiskGradeZ.png";
                                }
                                totalGradeCircle.appendChild(image);
                            } else {
                                document.getElementById("totalGrade").innerHTML = '<div class="widget-thumb-body-stat longTextWrap" style="text-align: center; font-size: 107px; margin-bottom: 5px;"><b>-</b></div>';
                                ;
                            }
                            return json.data;
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="listVulnerabilities.tableError"/>");
                            $("#alertModal").modal("show");
                        }
                    },
                    "initComplete": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $('[data-toggle="popover"]').popover({html: true});
                    },
                    "drawCallback": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $('[data-toggle="popover"]').popover({html: true});
                        $("#riskReportTable thead").remove();
                    },
                    "language": {
                        "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>")
                    }
                });
            }
            function vulnStatuses() {
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["filtered"] = filtered;
                $.post("..//dashboard/vulnerabilityStatusCounts.json", obj).done(function (result) {
                    temp = result;
                }).always(function () {
                    var combined = [];
                    combined[0] = {"name": decodeHtml("<spring:message code="genericdb.OPEN"/>"), "value": temp[0]};
                    combined[1] = {"name": decodeHtml("<spring:message code="genericdb.CLOSED"/>"), "value": temp[1]};
                    combined[2] = {"name": decodeHtml("<spring:message code="genericdb.RISK_ACCEPTED"/>"), "value": temp[2]};
                    combined[3] = {"name": decodeHtml("<spring:message code="genericdb.RECHECK"/>"), "value": temp[3]};
                    combined[4] = {"name": decodeHtml("<spring:message code="genericdb.ON_HOLD"/>"), "value": temp[4]};
                    combined[5] = {"name": decodeHtml("<spring:message code="genericdb.IN_PROGRESS"/>"), "value": temp[5]};
                    combined[6] = {"name": decodeHtml("<spring:message code="genericdb.FALSE_POSITIVE"/>"), "value": temp[6]};

                    $('#chartdiv').css("line-height", "");
                    chartdiv.data = combined;

                });
            }


            function topkb() {
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["limit"] = 10;
                obj["filtered"] = filtered;
                $.post("..//dashboard/top10kb.json", obj).done(function (result) {
                    temp = result;
                }).always(function () {
                    var combined = [];
                    for (var i = 0; i < temp.length; i++) {
                        combined[i] = {"name": decodeHtml(<c:out value = "temp[i].name"/>), "value": <c:out value = "temp[i].count"/>};
                    }
                    if (0 === combined.length) {
                        /* $('#topkbgraph').removeAttr('style');
                         $('#topkbgraph').css("text-align", "center");
                         $('#topkbgraph').css("width:", "100%");
                         $('#topkbgraph').css("height", "500px");
                         $('#topkbgraph').css("line-height", "500px");
                         $('#topkbgraph').text("<spring:message code="generic.emptyGraph"/>");*/
                        topkbgraph.data = [];
                        topkbIndicator.show();
                    } else {
                        $('#top1bgraph').css("line-height", "");
                        topkbgraph.data = combined;
                        topkbIndicator.hide();


                    }
                });
            }

            function riskyVul() {
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["page"] = 'report';
                obj["allOrTen"] = 'ten';
                obj["filtered"] = filtered;
                $.post("..//dashboard/loadTopTenVulnerabilities.json", obj).done(function (result) {
                    temp = result;
                }).always(function () {
                    var combined = [];
                        for (var i = 0; i < temp.length; i++) {
                            var riskScore = Math.round(<c:out value = "temp[i].riskScore"/> * 10) / 10;
                            combined[i] = {"name": decodeHtml(<c:out value = "temp[i].vulnerability.name"/>), "value": riskScore};
                        }
                    if (0 === combined.length) {
                        /* $('#riskyVulgraph').removeAttr('style');
                         $('#riskyVulgraph').css("text-align", "center");
                         $('#riskyVulgraph').css("width:", "100%");
                         $('#riskyVulgraph').css("height", "500px");
                         $('#riskyVulgraph').css("line-height", "500px");
                         $('#riskyVulgraph').text("<spring:message code="generic.emptyGraph"/>");*/
                        riskyVulgraph.data = [];
                        riskyVulIndicator.show();
                    } else {
                        $('#riskyVulgraph').css("line-height", "");
                        riskyVulgraph.data = combined;
                        riskyVulIndicator.hide();

                    }
                });
            }

            function topIp() {
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["limit"] = 10;
                obj["filtered"] = filtered;
                $.post("..//dashboard/top10ip.json", obj).done(function (result) {
                    temp = result;
                }).always(function () {
                    var combined = [];
                    for (var i = 0; i < temp.length; i++) {
                        combined[i] = {"name": decodeHtml(<c:out value = "temp[i].ip"/>), "value": <c:out value = "temp[i].vulnerabilityCount"/>};
                    }
                    if (0 === combined.length) {
                        var emptyData = [];
                        emptyData[0] = {"name": "", "id": "", "value": 0};
                        /* $('#topIpgraph').removeAttr('style');
                         $('#topIpgraph').css("text-align", "center");
                         $('#topIpgraph').css("width:", "100%");
                         $('#topIpgraph').css("height", "500px");
                         $('#topIpgraph').css("line-height", "500px");
                         $('#topIpgraph').text("<spring:message code="generic.emptyGraph"/>");*/
                        topIpgraph.data = emptyData;
                        topIpIndicator.show();
                    } else {
                        $('#topIpgraph').css("line-height", "");
                        topIpgraph.data = combined;
                        topIpIndicator.hide();

                    }
                });
            }

            function assetScore() {
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["limit"] = 10;
                obj["filtered"] = filtered;
                $.post("..//dashboard/assetscore.json", obj).done(function (result) {
                    temp = result;
                }).always(function () {
                    var combined = [];
                    for (var i = 0; i < temp.length; i++) {
                        combined[i] = {"name": decodeHtml(<c:out value = "temp[i].ip"/>), "value": <c:out value = "temp[i].score"/>};
                    }
                    if (0 === combined.length) {
                        /*$('#assetScoregraph').removeAttr('style');
                         $('#assetScoregraph').css("text-align", "center");
                         $('#assetScoregraph').css("width:", "100%");
                         $('#assetScoregraph').css("height", "500px");
                         $('#assetScoregraph').css("line-height", "500px");
                         $('#assetScoregraph').text("<spring:message code="generic.emptyGraph"/>");*/
                        assetScoregraph.data = [];
                        assetScoreIndicator.show();
                    } else {
                        $('#assetScoregraph').css("line-height", "");
                        assetScoregraph.data = combined;
                        assetScoreIndicator.hide();

                    }
                });
            }

            function openVul() {
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["limit"] = 10;
                $.post("open20Vul.json", obj).done(function (result) {
                    temp = result;
                }).always(function () {
                    var combined = [];
                    for (var i = 0; i < temp.length; i++) {
                        combined[i] = {"name": decodeHtml(temp[i].name + ' (' + temp[i].ip + ') [' + temp[i].assignee + ']'), "value": temp[i].timeDif};
                    }
                    if (0 === combined.length) {
                        /* $('#openVulgraph').removeAttr('style');
                         $('#openVulgraph').css("text-align", "center");
                         $('#openVulgraph').css("width:", "100%");
                         $('#openVulgraph').css("height", "500px");
                         $('#openVulgraph').css("line-height", "500px");
                         $('#openVulgraph').text("<spring:message code="generic.emptyGraph"/>");*/
                        openVulgraph.data = [];
                        openVulIndicator.show();
                    } else {
                        $('#openVulgraph').css("line-height", "");
                        openVulgraph.data = combined;
                        openVulIndicator.hide();

                    }
                });
            }

            function closedVulAssignee() {
                var temp;
                var obj = getObjectByForm("searchForm");
                obj["limit"] = 10;
                $.post("closedVul20Assignee.json", obj).done(function (result) {
                    temp = result;
                }).always(function () {
                    var combined = [];
                    for (var i = 0; i < temp.length; i++) {
                        combined[i] = {"name": decodeHtml(temp[i].assigneeName), "value": temp[i].assigneeCount};
                    }
                    if (0 === combined.length) {
                        /* $('#closedVulAssigneegraph').removeAttr('style');
                         $('#closedVulAssigneegraph').css("text-align", "center");
                         $('#closedVulAssigneegraph').css("width:", "100%");
                         $('#closedVulAssigneegraph').css("height", "500px");
                         $('#closedVulAssigneegraph').css("line-height", "500px");
                         $('#closedVulAssigneegraph').text("<spring:message code="generic.emptyGraph"/>");*/
                        closedVulAssigneegraph.data = [];
                        closedVulAssigneeIndicator.show();
                    } else {
                        $('#closedVulAssigneegraph').css("line-height", "");
                        closedVulAssigneegraph.data = combined;
                        closedVulAssigneeIndicator.hide();

                    }
                });
            }
            $(document).ready(function () {

                /*
                 * amChart4 Grafikleri
                 * --------------------
                 */
                function am4themes_bizzyTheme(target) {
                    if (target instanceof am4core.ColorSet) {
                        target.list = [
                            am4core.color("#456173"),
                            am4core.color("#cacaca"),
                            am4core.color("#1b3c59"),
                            am4core.color("#e6b31e"),
                            am4core.color("#f95959"),
                            am4core.color("#f73859"),
                            am4core.color("#f1d18a"),
                            am4core.color("#e6b31e"),
                            am4core.color("#f1e58a"),
                            am4core.color("#344652"),
                            am4core.color("#101f2a"),
                            am4core.color("#ffb143")
                        ];
                    }
                }
                am4core.useTheme(am4themes_animated);
                am4core.useTheme(am4themes_bizzyTheme);

                am4core.options.commercialLicense = true;

                /* Sabit Üst:  EN RİSKLİ 10 ZAFİYET*/
                riskyVulgraph = am4core.create("riskyVulgraph", am4charts.XYChart3D);
                // Create axes
                var categoryAxis = riskyVulgraph.yAxes.push(new am4charts.CategoryAxis());
                categoryAxis.dataFields.category = "name";
                categoryAxis.renderer.labels.template.hideOversized = false;
                categoryAxis.renderer.minGridDistance = 30;
                categoryAxis.renderer.labels.template.horizontalCenter = "right";
                categoryAxis.renderer.labels.template.verticalCenter = "middle";
                categoryAxis.tooltip.label.horizontalCenter = "right";
                categoryAxis.tooltip.label.verticalCenter = "middle";
                categoryAxis.cursorTooltipEnabled = false;
                categoryAxis.renderer.inside = true;
                categoryAxis.renderer.labels.template.dy = -29;
                categoryAxis.renderer.labels.template.dx = 20;
                categoryAxis.renderer.grid.template.disabled = true;

                var label = categoryAxis.renderer.labels.template;
                //label.truncate = true;
                //label.maxWidth = 250;
                riskyVulgraph.events.on("ready", function () {
                    categoryAxis.zoom({
                        start: 0,
                        end: 1
                    });
                });
                var valueAxis = riskyVulgraph.xAxes.push(new am4charts.ValueAxis());
                valueAxis.cursorTooltipEnabled = false;

                // Create series
                var series = riskyVulgraph.series.push(new am4charts.ColumnSeries3D());
                series.dataFields.valueX = "value";
                series.dataFields.categoryY = "name";
                series.name = "value";
                series.tooltipText = "{categoryY}: [bold]{valueX}[/]";
                series.columns.template.fillOpacity = .8;
                series.columns.template.width = am4core.percent(35);
                series.columns.template.height = am4core.percent(35);
                series.columns.template.column3D.stroke = am4core.color("#fff");
                series.columns.template.column3D.strokeOpacity = 0.2;

                var columnTemplate = series.columns.template;
                columnTemplate.strokeWidth = 2;
                columnTemplate.strokeOpacity = 1;
                columnTemplate.stroke = am4core.color("#FFFFFF");

                columnTemplate.adapter.add("fill", function (fill, target) {
                    return riskyVulgraph.colors.getIndex(target.dataItem.index);
                });

                columnTemplate.adapter.add("stroke", function (stroke, target) {
                    return riskyVulgraph.colors.getIndex(target.dataItem.index);
                });

                riskyVulgraph.cursor = new am4charts.XYCursor();
                riskyVulgraph.cursor.lineX.strokeOpacity = 0;
                riskyVulgraph.cursor.lineY.strokeOpacity = 0;
                riskyVulgraph.events.on("beforedatavalidated", function (ev) {
                    riskyVulgraph.data.sort(function (a, b) {
                        return (a.value) - (b.value);
                    });
                });
                riskyVulIndicator = riskyVulgraph.tooltipContainer.createChild(am4core.Container);
                riskyVulIndicator.background.fill = am4core.color("#fff");
                riskyVulIndicator.background.fillOpacity = 0.8;
                riskyVulIndicator.width = am4core.percent(100);
                riskyVulIndicator.height = am4core.percent(100);

                var riskyVulIndicatorLabel = riskyVulIndicator.createChild(am4core.Label);
                riskyVulIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
                riskyVulIndicatorLabel.align = "center";
                riskyVulIndicatorLabel.valign = "middle";
                riskyVulIndicatorLabel.fontSize = 12;

                /* Sabit Üst:  EN RİSKLİ 10 ZAFİYET*/
                topkbgraph = am4core.create("topkbgraph", am4charts.XYChart3D);
                // Create axes
                var categoryAxis = topkbgraph.yAxes.push(new am4charts.CategoryAxis());
                categoryAxis.dataFields.category = "name";
                categoryAxis.renderer.labels.template.hideOversized = false;
                categoryAxis.renderer.minGridDistance = 30;
                categoryAxis.renderer.labels.template.horizontalCenter = "right";
                categoryAxis.renderer.labels.template.verticalCenter = "middle";
                categoryAxis.tooltip.label.horizontalCenter = "right";
                categoryAxis.tooltip.label.verticalCenter = "middle";
                categoryAxis.cursorTooltipEnabled = false;
                categoryAxis.renderer.inside = true;
                categoryAxis.renderer.labels.template.dy = -29;
                categoryAxis.renderer.labels.template.dx = 20;
                categoryAxis.renderer.grid.template.disabled = true;

                var label = categoryAxis.renderer.labels.template;
                //label.truncate = true;
                //label.maxWidth = 250;
                topkbgraph.events.on("ready", function () {
                    categoryAxis.zoom({
                        start: 0,
                        end: 1
                    });
                });
                var valueAxis = topkbgraph.xAxes.push(new am4charts.ValueAxis());
                valueAxis.cursorTooltipEnabled = false;

                // Create series
                var series = topkbgraph.series.push(new am4charts.ColumnSeries3D());
                series.dataFields.valueX = "value";
                series.dataFields.categoryY = "name";
                series.name = "value";
                series.tooltipText = "{categoryY}: [bold]{valueX}[/]";
                series.columns.template.fillOpacity = .8;
                series.columns.template.width = am4core.percent(35);
                series.columns.template.height = am4core.percent(35);
                series.columns.template.column3D.stroke = am4core.color("#fff");
                series.columns.template.column3D.strokeOpacity = 0.2;

                var columnTemplate = series.columns.template;
                columnTemplate.strokeWidth = 2;
                columnTemplate.strokeOpacity = 1;
                columnTemplate.stroke = am4core.color("#FFFFFF");

                columnTemplate.adapter.add("fill", function (fill, target) {
                    return topkbgraph.colors.getIndex(target.dataItem.index);
                });

                columnTemplate.adapter.add("stroke", function (stroke, target) {
                    return topkbgraph.colors.getIndex(target.dataItem.index);
                });

                topkbgraph.cursor = new am4charts.XYCursor();
                topkbgraph.cursor.lineX.strokeOpacity = 0;
                topkbgraph.cursor.lineY.strokeOpacity = 0;
                topkbgraph.events.on("beforedatavalidated", function (ev) {
                    topkbgraph.data.sort(function (a, b) {
                        return (a.value) - (b.value);
                    });
                });

                topkbIndicator = topkbgraph.tooltipContainer.createChild(am4core.Container);
                topkbIndicator.background.fill = am4core.color("#fff");
                topkbIndicator.background.fillOpacity = 0.8;
                topkbIndicator.width = am4core.percent(100);
                topkbIndicator.height = am4core.percent(100);

                var topkbIndicatorLabel = topkbIndicator.createChild(am4core.Label);
                topkbIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
                topkbIndicatorLabel.align = "center";
                topkbIndicatorLabel.valign = "middle";
                topkbIndicatorLabel.fontSize = 12;

                /* Sabit Üst:  EN RİSKLİ 10 ZAFİYET*/
                openVulgraph = am4core.create("openVulgraph", am4charts.XYChart3D);
                // Create axes
                var categoryAxis = openVulgraph.yAxes.push(new am4charts.CategoryAxis());
                categoryAxis.dataFields.category = "name";
                categoryAxis.renderer.labels.template.hideOversized = false;
                categoryAxis.renderer.minGridDistance = 30;
                categoryAxis.renderer.labels.template.horizontalCenter = "right";
                categoryAxis.renderer.labels.template.verticalCenter = "middle";
                categoryAxis.tooltip.label.horizontalCenter = "right";
                categoryAxis.tooltip.label.verticalCenter = "middle";
                categoryAxis.cursorTooltipEnabled = false;
                categoryAxis.renderer.inside = true;
                categoryAxis.renderer.labels.template.dy = -29;
                categoryAxis.renderer.labels.template.dx = 20;
                categoryAxis.renderer.grid.template.disabled = true;

                var label = categoryAxis.renderer.labels.template;
                //label.truncate = true;
                //label.maxWidth = 250;
                openVulgraph.events.on("ready", function () {
                    categoryAxis.zoom({
                        start: 0,
                        end: 1
                    });
                });
                var valueAxis = openVulgraph.xAxes.push(new am4charts.ValueAxis());
                valueAxis.cursorTooltipEnabled = false;

                // Create series
                var series = openVulgraph.series.push(new am4charts.ColumnSeries3D());
                series.dataFields.valueX = "value";
                series.dataFields.categoryY = "name";
                series.name = "value";
                series.tooltipText = "{categoryY}: [bold]{valueX}[/]";
                series.columns.template.fillOpacity = .8;
                series.columns.template.width = am4core.percent(35);
                series.columns.template.height = am4core.percent(35);
                series.columns.template.column3D.stroke = am4core.color("#fff");
                series.columns.template.column3D.strokeOpacity = 0.2;

                var columnTemplate = series.columns.template;
                columnTemplate.strokeWidth = 2;
                columnTemplate.strokeOpacity = 1;
                columnTemplate.stroke = am4core.color("#FFFFFF");

                columnTemplate.adapter.add("fill", function (fill, target) {
                    return openVulgraph.colors.getIndex(target.dataItem.index);
                });

                columnTemplate.adapter.add("stroke", function (stroke, target) {
                    return openVulgraph.colors.getIndex(target.dataItem.index);
                });

                openVulgraph.cursor = new am4charts.XYCursor();
                openVulgraph.cursor.lineX.strokeOpacity = 0;
                openVulgraph.cursor.lineY.strokeOpacity = 0;
                openVulgraph.events.on("beforedatavalidated", function (ev) {
                    openVulgraph.data.sort(function (a, b) {
                        return (a.value) - (b.value);
                    });
                });
                openVulIndicator = openVulgraph.tooltipContainer.createChild(am4core.Container);
                openVulIndicator.background.fill = am4core.color("#fff");
                openVulIndicator.background.fillOpacity = 0.8;
                openVulIndicator.width = am4core.percent(100);
                openVulIndicator.height = am4core.percent(100);

                var openVulIndicatorLabel = openVulIndicator.createChild(am4core.Label);
                openVulIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
                openVulIndicatorLabel.align = "center";
                openVulIndicatorLabel.valign = "middle";
                openVulIndicatorLabel.fontSize = 12;


                /* Varlık Tabı: EN RİSKLİ 10 VARLIK*/
                assetScoregraph = am4core.create("assetScoregraph", am4charts.PieChart3D);
                assetScoregraph.hiddenState.properties.opacity = 0; // this creates initial fade-in

                assetScoregraph.data = [];

                assetScoregraph.innerRadius = am4core.percent(40);
                assetScoregraph.depth = 60;

                //assetScoregraph.legend = new am4charts.Legend();

                var series = assetScoregraph.series.push(new am4charts.PieSeries3D());
                series.dataFields.value = "value";
                series.dataFields.depthValue = "value";
                series.dataFields.category = "name";

                assetScoregraph.innerRadius = 100;
                var label = assetScoregraph.seriesContainer.createChild(am4core.Label);
                label.text = "<spring:message code="dashboard.riskScoreName"/>";
                label.horizontalCenter = "middle";
                label.verticalCenter = "middle";
                label.fontSize = 25;

                series.labels.template.text = "{name}:{value}";
                series.slices.template.cornerRadius = 5;
                series.colors.step = 3;

                series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                series.slices.template.interactionsEnabled = true;
                series.slices.template.events.on("hit", function (ev) {
                    var url = '../customer/listVulnerabilities.htm?assetId=' + ev.target.dataItem.dataContext.id;
                    url = addFilterToUrl(url);
                    window.open(url, '_blank');
                },
                        this
                        );

                assetScoreIndicator = assetScoregraph.tooltipContainer.createChild(am4core.Container);
                assetScoreIndicator.background.fill = am4core.color("#fff");
                assetScoreIndicator.background.fillOpacity = 0.8;
                assetScoreIndicator.width = am4core.percent(100);
                assetScoreIndicator.height = am4core.percent(100);

                var assetScoreIndicatorLabel = assetScoreIndicator.createChild(am4core.Label);
                assetScoreIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
                assetScoreIndicatorLabel.align = "center";
                assetScoreIndicatorLabel.valign = "middle";
                assetScoreIndicatorLabel.fontSize = 12;
                
                /* Sabit Üst: ZAFİYET DURUMU GRAFİĞİ donutchart*/
                chartdiv = am4core.create("chartdiv", am4charts.PieChart);
                chartdiv.hiddenState.properties.opacity = 0; // this creates initial fade-in
                chartdiv.innerRadius = am4core.percent(40);
                chartdiv.depth = 20;
                // Add and configure Series
                var pieSeries = chartdiv.series.push(new am4charts.PieSeries());
                pieSeries.dataFields.value = "value";
                pieSeries.dataFields.category = "name";
                pieSeries.dataFields.depthValue = "value";
                pieSeries.innerRadius = am4core.percent(40);
                pieSeries.ticks.template.disabled = true;
                pieSeries.labels.template.disabled = true;
                pieSeries.slices.template.cornerRadius = 5;
                pieSeries.colors = colorSet;

                chartdiv.legend = new am4charts.Legend();
                var legendContainer = am4core.create("legenddiv", am4core.Container);
                legendContainer.width = am4core.percent(100);
                legendContainer.height = am4core.percent(100);
                chartdiv.legend.parent = legendContainer;
                chartdiv.legend.scale = 0.5;
                chartdiv.legend.fontSize = 18;
                chartdiv.scale = 1.1;
                
                pieSeries.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                pieSeries.slices.template.interactionsEnabled = true;
                pieSeries.slices.template.events.on("hit", function (ev) {
                    var url = '../customer/listVulnerabilities.htm?statusValues=' + ev.target.dataItem.dataContext.status;
                    url = addFilterToUrl(url);
                    window.open(url, '_blank');
                },this);

                /* Port Tabı:  PORTLARA GÖRE ZAFİYETLERİN DAĞILIMI*/
                closedVulAssigneegraph = am4core.create("closedVulAssigneegraph", am4charts.PieChart3D);
                closedVulAssigneegraph.hiddenState.properties.opacity = 0; // this creates initial fade-in

                var series = closedVulAssigneegraph.series.push(new am4charts.PieSeries3D());
                series.dataFields.value = "value";
                series.dataFields.category = "name";
                var label = series.labels.template;
                label.truncate = true;
                label.maxWidth = 100;
                series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                series.slices.template.events.on("hit", function (ev) {
                    var url = '../customer/listAssets.htm?serviceValue=' + ev.target.dataItem.dataContext.name;
                    url = addFilterToUrl(url);
                    window.open(url, '_blank');
                },
                        this
                        );

                closedVulAssigneeIndicator = closedVulAssigneegraph.tooltipContainer.createChild(am4core.Container);
                closedVulAssigneeIndicator.background.fill = am4core.color("#fff");
                closedVulAssigneeIndicator.background.fillOpacity = 0.8;
                closedVulAssigneeIndicator.width = am4core.percent(100);
                closedVulAssigneeIndicator.height = am4core.percent(100);

                var closedVulAssigneeIndicatorLabel = closedVulAssigneeIndicator.createChild(am4core.Label);
                closedVulAssigneeIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
                closedVulAssigneeIndicatorLabel.align = "center";
                closedVulAssigneeIndicatorLabel.valign = "middle";
                closedVulAssigneeIndicatorLabel.fontSize = 12;

                /* Varlık Tabı: EN ÇOK ZAFİYETE SAHİP IP*/
                topIpgraph = am4core.create("topIpgraph", am4charts.RadarChart);

                /* Create axes */
                var categoryAxis = topIpgraph.xAxes.push(new am4charts.CategoryAxis());
                categoryAxis.dataFields.category = "name";

                var valueAxis = topIpgraph.yAxes.push(new am4charts.ValueAxis());
                valueAxis.extraMin = 0.2;
                valueAxis.extraMax = 0.2;
                valueAxis.tooltip.disabled = true;

                /* Create and configure series */
                var series1 = topIpgraph.series.push(new am4charts.RadarSeries());
                series1.dataFields.valueY = "value";
                series1.dataFields.categoryX = "name";
                series1.strokeWidth = 3;
                series1.tooltipText = "{valueY}";
                series1.bullets.create(am4charts.CircleBullet);
                topIpgraph.interactionsEnabled = true;
                topIpgraph.events.on("hit", function (ev) {
                    /*var url = '../customer/listVulnerabilities.htm?assetId=' + e.item.dataContext.id;
                     url = addFilterToUrl(url);
                     window.open(url,'_blank');*/
                });
                topIpgraph.cursor = new am4charts.RadarCursor();

                topIpIndicator = topIpgraph.tooltipContainer.createChild(am4core.Container);
                topIpIndicator.background.fill = am4core.color("#fff");
                topIpIndicator.background.fillOpacity = 0.8;
                topIpIndicator.width = am4core.percent(100);
                topIpIndicator.height = am4core.percent(100);

                var topIpIndicatorLabel = topIpIndicator.createChild(am4core.Label);
                topIpIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
                topIpIndicatorLabel.align = "center";
                topIpIndicatorLabel.valign = "middle";
                topIpIndicatorLabel.fontSize = 12;



                $('#dateTimeScan').daterangepicker({
                });
                $('#riskReportTable').on('load', loadRiskReportTable());
                if (dayDifference > 0) {
                    $("#circleYesterday").html('<i class="fas fa-arrow-circle-up" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>'); 
                    $('#riskDiffYesterday').html(dayDifference);
                    $('#riskDiffYesterday').css("color","rgba(207, 0, 15, 1)");
                } else if (dayDifference === 0) {
                    $("#circleYesterday").html('<i class="fas fa-arrow-circle-right" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');
                    $('#riskDiffYesterday').html(dayDifference);
                } else {
                    $("#circleYesterday").html('<i class="fas fa-arrow-circle-down" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');
                    $('#riskDiffYesterday').html(dayDifference);
                    $('#riskDiffYesterday').css("color","rgba(0, 230, 64, 1)");
                }
                $('#riskDiffYesterday').css("font-weight", "bold");
                $('#riskDiffYesterday').css("font-size", "14px");

                if (weekDifference > 0) {
                    $("#circleLastWeek").html('<i class="fas fa-arrow-circle-up" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>');
                    $('#riskDiffLastWeek').text(weekDifference);
                    $('#riskDiffLastWeek').css("color","rgba(207, 0, 15, 1)");
                } else if (weekDifference === 0) {
                    $("#circleLastWeek").html('<i class="fas fa-arrow-circle-right" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');
                    $('#riskDiffLastWeek').text(weekDifference);
                } else {
                    $("#circleLastWeek").html('<i class="fas fa-arrow-circle-down" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');
                    $('#riskDiffLastWeek').text(weekDifference);
                    $('#riskDiffLastWeek').css("color","rgba(0, 230, 64, 1)");
                }
                $('#riskDiffLastWeek').css("font-weight", "bold");
                $('#riskDiffLastWeek').css("font-size", "14px");

                if (monthDifference > 0) {
                    $("#circleLastMonth").html('<i class="fas fa-arrow-circle-up" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>');
                    $('#riskDiffLastMonth').text(monthDifference);
                    $('#riskDiffLastMonth').css("color","rgba(207, 0, 15, 1)");
                } else if (monthDifference === 0) {
                   $("#circleLastMonth").html('<i class="fas fa-arrow-circle-right" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');
                   $('#riskDiffLastMonth').text(monthDifference);
                } else {
                    $("#circleLastMonth").html('<i class="fas fa-arrow-circle-down" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');
                    $('#riskDiffLastMonth').text(monthDifference);
                    $('#riskDiffLastMonth').css("color","rgba(0, 230, 64, 1)");
                }
                $('#riskDiffLastMonth').css("font-weight", "bold");
                $('#riskDiffLastMonth').css("font-size", "14px");
                //$('#riskDiffYesterday').text(dayDifference);
                //$('#riskDiffLastWeek').text(weekDifference);
                //$('#riskDiffLastMonth').text(monthDifference);
                $('#topkbgraph').on('load', topkb());
                $('#riskyVulgraph').on('load', riskyVul());
                $('#topIpgraph').on('load', topIp());
                $('#assetScoregraph').on('load', assetScore());
                $('#openVulgraph').on('load', openVul());
                $('#chartdiv').on('load', vulnStatuses());
                $('#closedVulAssigneegraph').on('load', closedVulAssignee());
            });
            function getManagerReport() {
                $('#report').modal('show');
            }
            function closeReportModal() {
                $('#reportName').val("");
                document.getElementById("statusErrorTag").style.visibility = "hidden";
                $('#report').modal('hide');
            }
            function reportNameControl(){
                var text = document.getElementById("reportName");
                if (!text.value || text.value.length === 0) {
                document.getElementById("statusErrorTag").style.visibility = "visible";
                //return 'fail';
                } else {
                var obj = {};
                var tempObj = getObjectByForm("searchForm");
                Object.keys(tempObj).forEach(function (key) {
                    obj[key] = tempObj[key];
                });
                obj["reportName"] = $('#reportName').val();
                obj["limit"] = 10;
                generateReport("getManagerReport.json", obj, "<spring:message code="report.reportCreation"/>", 
                        "<spring:message code="listVulnerabilities.reportError"/>", "<spring:message code="listVulnerability.noData"/>");
                closeReportModal();
                }
            }
            var filtered = "";
            function filterGraphs() {
                var obj = getObjectByForm("searchForm");
                var defaultFilter = true;
                var riskLevels = ["1","2","3","4","5"];
                var statuses = ["OPEN","RISK_ACCEPTED","RECHECK","ON_HOLD","IN_PROGRESS"];
                if(defaultFilter && $("#riskLevels").val().length !== riskLevels.length) {
                    defaultFilter = false;
                }
                if(defaultFilter) {
                        $.each($("#riskLevels").val().sort(), function(index, value) {
                        if(value !== riskLevels.sort()[index]) {
                            defaultFilter = false;
                        }
                    }); 
                }
                if(defaultFilter && $("#statuses").val().length !== statuses.length) {
                    defaultFilter = false;
                }
                if(defaultFilter) {
                    $.each($("#statuses").val().sort(), function(index, value) {
                        if(value !== statuses.sort()[index]) {
                            defaultFilter = false;
                        }
                    });
                }
                if(defaultFilter && ($("#groups").val().length > 0 || $("#labels").val().length > 0 || $("#scans").val().length > 0 || $("#daterange").val().length > 0)) {
                    defaultFilter = false;
                }
                if(defaultFilter) {
                    filtered = "";
                } else {
                    filtered = "on";
                } 

                $.post("loadTendencyReport.json", obj).done(function (result) {
                    $('#riskScoreToday').text(result[0]);
                    riskScoreDiffFilter(result.slice(1, 4));
                    $('#riskReportTable').DataTable().clear();
                    $('#riskReportTable').DataTable().destroy();
                    loadRiskReportTable();
                    topkb();
                    riskyVul();
                    topIp();
                    assetScore();
                    openVul();
                    vulnStatuses();
                    closedVulAssignee();
                });
            }
            function riskScoreDiffFilter(data) {
                var dayDiff = data[0];
                var weekDiff = data[1];
                var monthDiff = data[2];

                if (dayDiff > 0) {
                    $("#circleYesterday").html('<i class="fas fa-arrow-circle-up" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>'); 
                    $('#riskDiffYesterday').html(dayDiff);
                    $('#riskDiffYesterday').css("color","rgba(207, 0, 15, 1)");
                } else if (dayDiff === 0) {
                    $("#circleYesterday").html('<i class="fas fa-arrow-circle-right" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');
                    $('#riskDiffYesterday').html(dayDiff);
                } else {
                    $("#circleYesterday").html('<i class="fas fa-arrow-circle-down" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');
                    $('#riskDiffYesterday').html(dayDiff);
                    $('#riskDiffYesterday').css("color","rgba(0, 230, 64, 1)");
                }
                $('#riskDiffYesterday').css("font-weight", "bold");
                $('#riskDiffYesterday').css("font-size", "14px");

                if (weekDiff > 0) {
                    $("#circleLastWeek").html('<i class="fas fa-arrow-circle-up" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>');
                    $('#riskDiffLastWeek').text(weekDiff);
                    $('#riskDiffLastWeek').css("color","rgba(207, 0, 15, 1)");
                } else if (weekDiff === 0) {
                    $("#circleLastWeek").html('<i class="fas fa-arrow-circle-right" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');
                    $('#riskDiffLastWeek').text(weekDiff);
                } else {
                    $("#circleLastWeek").html('<i class="fas fa-arrow-circle-down" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');
                    $('#riskDiffLastWeek').text(weekDiff);
                    $('#riskDiffLastWeek').css("color","rgba(0, 230, 64, 1)");
                }
                $('#riskDiffLastWeek').css("font-weight", "bold");
                $('#riskDiffLastWeek').css("font-size", "14px");

                if (monthDiff > 0) {
                    $("#circleLastMonth").html('<i class="fas fa-arrow-circle-up" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>');
                    $('#riskDiffLastMonth').text(monthDiff);
                    $('#riskDiffLastMonth').css("color","rgba(207, 0, 15, 1)");
                } else if (monthDiff === 0) {
                   $("#circleLastMonth").html('<i class="fas fa-arrow-circle-right" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');
                   $('#riskDiffLastMonth').text(monthDiff);
                } else {
                    $("#circleLastMonth").html('<i class="fas fa-arrow-circle-down" style="font-size:17px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');
                    $('#riskDiffLastMonth').text(monthDiff);
                    $('#riskDiffLastMonth').css("color","rgba(0, 230, 64, 1)");
                }
                $('#riskDiffLastMonth').css("font-weight", "bold");
                $('#riskDiffLastMonth').css("font-size", "14px");
            }

        </script>
          <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
          <jsp:include page="/WEB-INF/jsp/tool/alertModal.jsp" />
        <div class="row">
            <div class="col-lg-12">
                <h3 class="page-title">
                    <ul class="page-breadcrumb breadcrumb"> <li>
                            <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                            <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                        </li>
                        <li>
                            <span class="title2"><spring:message code="managerReport.title"/></span>
                        </li>
                    </ul>
                </h3>
            </div>
        </div>
        <div class="row" id="SearchPanel">
            <div class="col-lg-12">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title" id="VulnerabilitySearchLabel">
                        <div class="tools" style="float: left">                                            
                            <a data-toggle="collapse" onclick="$('#searchPanelLink').trigger('click');">
                                <i class="icon-magnifier" style="margin-left: 5px; padding-right: 3px"></i>
                                <spring:message code="generic.detailedSearch"/>
                            </a>
                            <a id='searchPanelLink' class="collapse" data-toggle="collapse" onclick="showSearchDiv('collapseSearch')" class="btn btn-link">
                            </a>
                        </div>
                    </div>
                    <div id="collapseSearch" style ="display : none;" class="panel-collapse collapse in" >
                        <div class="portlet-body">
                            <div class="form-group">
                                <form:form id="searchForm" tabindex="0" style="outline: none;">
                                    <div class="row" style="margin-bottom: 1em;">
                                        <label class="col-lg-1 control-label" ><b><spring:message code="listReports.status"/></b></label>
                                        <div class="col-lg-2">
                                            <select id ="statuses" name="statuses" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%">
                                                <option value="OPEN" selected><spring:message code="genericdb.OPEN"/></option>
                                                <option value="CLOSED"><spring:message code="genericdb.CLOSED"/></option>
                                                <option value="RISK_ACCEPTED" selected><spring:message code="genericdb.RISK_ACCEPTED"/></option>
                                                <option value="RECHECK" selected><spring:message code="genericdb.RECHECK"/></option>
                                                <option value="ON_HOLD" selected><spring:message code="genericdb.ON_HOLD"/></option>
                                                <option value="IN_PROGRESS" selected><spring:message code="genericdb.IN_PROGRESS"/></option>
                                                <option value="FALSE_POSITIVE"><spring:message code="genericdb.FALSE_POSITIVE"/></option>
                                            </select>
                                        </div>
                                        <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.riskLevel"/></b></label>
                                        <div class="col-lg-2">
                                            <select id ="riskLevels" name="riskLevels" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                                                <option value="5"><spring:message code="searchPanel.RiskLevel5"/></option>
                                                <option value="4"><spring:message code="searchPanel.RiskLevel4"/></option>
                                                <option value="3"><spring:message code="searchPanel.RiskLevel3"/></option>
                                                <option value="2"><spring:message code="searchPanel.RiskLevel2"/></option>
                                                <option value="1"><spring:message code="searchPanel.RiskLevel1"/></option>
                                                <option value="0"><spring:message code="searchPanel.RiskLevel0"/></option>
                                            </select>
                                        </div>
                                        <label class="col-lg-1 control-label" ><b><spring:message code="addAssetGroup.group"/></b></label>
                                        <div class="col-lg-2">
                                            <select id ="groups" name="groups" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                                                <c:forEach var="assetGroupElement" items="${groups}">
                                                    <option value='<c:out value="${assetGroupElement.groupId}"/>' ><c:out value="${assetGroupElement.name}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.labels"/></b></label>
                                        <div class="col-lg-2">
                                            <select id ="labels" name="labels" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                                                <option value="NULL"><spring:message code="searchPanel.nullRecors"/></option>
                                                <c:forEach items="${labels}" var="label">
                                                    <option value="<c:out value="${label.name}"/>"><c:out value="${label.name}"/></option>
                                                </c:forEach>    
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row" style="margin-bottom: 1em;">            
                                        <label class="col-lg-1 control-label" ><b><spring:message code="listVulnerabilities.dateRange"/></b></label>
                                        <div class="col-lg-2">
                                            <div class='input-group date' id='dateTimeScan'>
                                                <input name="dateRange" class="form-control" id="daterange" readonly>
                                                <span class="input-group-addon">
                                                    <span class="glyphicon glyphicon-calendar"></span>
                                                </span>
                                            </div>
                                        </div>
                                        <label class="col-lg-1 control-label" ><b><spring:message code="listFalsePositives.scan"/></b></label>
                                        <div class="col-lg-2">
                                            <select id ="scans" name="scans" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                                                <c:forEach var="completedScan" items="${scans}">
                                                    <option value='<c:out value="${completedScan.scanId}"/>' ><c:out value="${completedScan.name}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>   
                                    <div class="row" style="margin-bottom: 1em;">
                                        <div class="col-lg-3 right" style="float:right">
                                            <button type="button" onClick="filterGraphs()" class="btn btn-primary right" id="search" style="float:right;margin-left:0.2em"><spring:message code="generic.search"/></button>
                                            <button type="button" onClick="clearInDiv('SearchPanel')" class="btn btn-danger right " id="clear" style="float:right"><spring:message code="generic.clear"/></button>
                                        </div>
                                    </div>
                                </form:form>    
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="portlet light bordered shadow-soft">                    
                    <div class="portlet-body">
                        <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER')">
                            <a class="btn btn-primary btn-sm" onclick="getManagerReport()"><spring:message code="listAssets.getAssesmentReport"/></a>
                        </sec:authorize>
                    </div>
                </div>
            </div>
        </div>
        <div class="row widget-row">
            <div class="col-lg-4">
                <div class="widget-thumb widget-bg-color-white text-uppercase">
                    <h4 class="widget-thumb-heading" style="margin: 0"><spring:message code="riskNote.title"/>  </h4>
                                     <div class="container" style="width:100%">                
                                         <div  style="text-align: center;margin-top:5px; margin-left:auto;margin-right:auto;">
                            <div id='totalGrade'>
                            </div>                            
                        </div>
                    </div>
                </div> 
            </div>
            <div class="col-lg-4">
               <div id="alertbox" class="widget-thumb widget-bg-color-white text-uppercase" style="margin: 0px">
                    <h4 class="widget-thumb-heading" style="margin: 0"><spring:message code="dashboard.riskScoreName"/>  </h4>
                    <div class="portlet-body portlet-body-black" style="height: 90%; padding-left: 0px !important; padding-right: 0px !important;display: flex;">
                        <div id="riskScoreValue" style="width: 20%;height: 170px !important;flex: 0 0 35%;border-right: 1px solid #a7bdcd;">
                            <div style="width:100%;height:100%;text-align: center">
                                <img src="${context}/resources/logo/scoreCircle.png" style="margin-top:10px;height:85%"/>
                                <b><div style="color:#2e353c;font-size:20px;margin-top:-90px" id="riskScoreToday"><c:out value = "${point}"/></div></b>
                            </div> 
                        </div>         
                        <div id="riskScoreChangeDiv" style=" display: flex; flex-direction: column; width: 80%;height: 170px !important;flex: 1; margin-left: 5px">
                            <div class="row widget-row" style="margin-top: auto;" > 
                                    <div class ="col-sm-8">
                                    <b class="longTextWrap" style=" font-size: 14px;" ><spring:message code="accordingToYest.title"/></b>

                                </div>
                                <div class ="col-sm-4">
                                    <span id="riskDiffYesterday"></span>
                                    <span id="circleYesterday"></span>
                            </div>
                            </div>
                            <div class="row widget-row" style="margin-top: 15px;"> 
                                <div class ="col-sm-8">
                                    <b class="longTextWrap" style=" font-size: 14px;" ><spring:message code="accordingToLastWeek.title"/></b>

                                </div>
                                <div class ="col-sm-4">
                                    <span id="riskDiffLastWeek"></span>
                                    <span id="circleLastWeek"></span>
                                </div>
                            </div>
                            <div class="row widget-row" style="margin-top: 15px; margin-bottom: auto" > 
                                <div class ="col-sm-8">
                                    <b class="longTextWrap" style=" font-size: 14px;" ><spring:message code="accordingToLastMonth.title"/></b>

                                </div>
                                <div class ="col-sm-4">
                                    <span id="riskDiffLastMonth"></span>
                                    <span id="circleLastMonth"></span>
                                </div>
                            </div>         
                        </div>            
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="widget-thumb widget-bg-color-white " style="padding-bottom:3px;">
                    <h4 class="widget-thumb-heading text-uppercase" style="margin: 0"><spring:message code="vulnerabilityStatusGraph.title"/> </h4>
                  
                    <div class="container" style="width:100%"> 
                        <div>
                            <div id="legenddiv"></div>
                        </div>
                        <div  style="text-align: center;margin-top:5px; margin-left:auto;margin-right:auto;">
                            <div id="chartdiv" style="height : 165px;"></div>                
                        </div>
                        <div class="bizzy-help-tip " style="right:20px; "><i class="fas fa-info-circle" style="color: #black;"></i>
                            <p style="font-weight:500;"><spring:message code="tooltip.vulnerabilityStatusGraph"/></p>
                        </div> 
                    </div>
                </div> 
            </div>
        </div>
        <div class="row" style="margin-top:20px">
            <div class="col-lg-12">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"><spring:message code="riskReport.title"/></span>
                            <!--     <div class="bizzy-help-tip">
                                    <p> &bull;</p>
                                </div> !--> 
                        </div>
                    </div>                      
                    <div class="portlet-body">
                        <table width="100%" class="table table-striped table-bordered table-hover" id='riskReportTable'>

                        </table>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i><spring:message code="managerReport.riskyVulnerabilities" arguments="10"/></span>
                            <!--    <div class="bizzy-help-tip">
                                   <p> &bull;</p>
                               </div> !--> 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="flot-chart">
                            <div id="riskyVulgraph" style="width: 100%;height: 500px"></div>
                        </div>
                    </div>
                </div>
            </div>            
            <div class="col-lg-6">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i><spring:message code="managerReport.commonVulnerabilities" arguments="10"/></span>
                            <!--    <div class="bizzy-help-tip">
                                   <p> &bull;</p>
                               </div> !--> 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="flot-chart">
                            <div id="topkbgraph" style="width: 100%;height: 500px"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>

                            <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i><spring:message code="managerReport.riskyAssets" arguments="10"/></span>
                            <!--     <div class="bizzy-help-tip">
                                    <p> &bull;</p>
                                </div> !--> 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="flot-chart">
                            <div id="assetScoregraph" style="width: 100%;height: 500px"></div>
                        </div>
                    </div>
                </div>
            </div>            
            <div class="col-lg-6">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i><spring:message code="managerReport.vulnerableAssets" arguments="10"/></span>
                            <!--      <div class="bizzy-help-tip">
                                     <p> &bull;</p>
                                 </div> !--> 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="flot-chart">
                            <div id="topIpgraph" style="width: 100%;height: 500px"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i><spring:message code="managerReport.openVulnerabilities" arguments="10"/></span>
                            <!--    <div class="bizzy-help-tip">
                                   <p> &bull;</p>
                               </div>  !-->  
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="flot-chart">
                            <div id="openVulgraph" style="width: 100%;height: 500px"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i><spring:message code="managerReport.closedAssignee" arguments="10"/></span>
                            <!--      <div class="bizzy-help-tip">
                                     <p> &bull;</p>
                                 </div>  !--> 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="flot-chart">
                            <div id="closedVulAssigneegraph" style="width: 100%;height: 500px"></div>
                        </div>
                    </div>
                </div>
            </div> 
        </div>
        <div class="modal fade" id="report" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog" style="width:25%">
                    <div class="modal-content">
                        <div class="modal-header">
                            <spring:message code="listReports.title"/>
                        </div>
                        <div class="modal-body">                       
                            <div class="panel-body"> 
                                <div class="form-group required">
                                    <label><spring:message code="reviewReport.reportName"/></label>
                                    <div style="display:flex;">
                                        <input class="form-control" id ="reportName" maxlength="50" style="width:80%;">
                                        <span id ="reportExtension" style="width:20%;line-height:3;margin-left:2px;"><b>.pdf</b></span>   
                                    </div>
                                    <input type="hidden" id="reportType"/>
                                    <input type="hidden" id="reportSource"/>
                                </div>
                                <div class="form-group">
                                    <p id="statusErrorTag" style="color:red;visibility:hidden">
                                        <br><b><spring:message code="report.reportNameValidation"/></b></p>        
                                </div>    
                                <br>
                                <div class="modal-footer" id="download">
                                    <div class="row">
                                        <div class="row">
                                            <button type="buttonback" id="buttonback" onclick="closeReportModal();" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.back"/></button>
                                            <button onClick="reportNameControl()" id="downloadReport" class="btn btn-success success"><spring:message code="startScan.submitAttestation"/></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>       
                    </div>  
                </div>
            </div>
        <script type="text/javascript">
            $(function () {
                $('#daterange').daterangepicker({
                    autoUpdateInput: false,
                   locale :  <c:choose>
                            <c:when test="${language == 'tr'}">
                                 <c:out value = "turkish_daterangepicker"/>
                            </c:when>
                            <c:otherwise>
                                <c:out value = "english_daterangepicker"/>
                            </c:otherwise>                        
                        </c:choose>
                });
                $('#daterange').on('apply.daterangepicker', function (ev, picker) {
                    $(this).val(picker.startDate.format('DD.MM.YYYY') + '-' + picker.endDate.format('DD.MM.YYYY'));
                });
                $('#daterange').on('cancel.daterangepicker', function (ev, picker) {
                    $(this).val('');
                });
            });
            var map = {13: false};
            $('#searchForm').keydown(function (e) {
            if (e.keyCode in map) {
            map[e.keyCode] = true;
            if (map[13]) {
                filterGraphs();
             }
             }
            }).keyup(function (e) {
            if (e.keyCode in map) {
                map[e.keyCode] = false;
            }
            });
        </script>
    </body>
</html>

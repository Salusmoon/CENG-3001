<%--
Document   : index
Created on : Sep 9, 2014, 2:48:38 PM
Author     : aidikut
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="generic.bizzy"/></title>
    <c:set var="context" value="${pageContext.request.contextPath}" />
</head>
<body>
<link href="${context}/resources/css/dashboard.css" rel="stylesheet" type="text/css" />

<sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
    <script type="text/javascript">
        function openTab(evt, cityName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(cityName).style.display = "block";
            evt.currentTarget.className += " active";
        }
        function slaTimelineProjection(data) {
            if (data.slaPassed === "true") {
                if (data.statusId === "2") {
                    var percentage = data.slaPercentage + 1;
                    if (percentage > 87) {
                        percentage = 87;
                    }
                    return '<div data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="sla.totalTime"/>:' + '&nbsp;' + data.slaValue + ',' + '&nbsp;' + data.difTimeString + '" style="background-color:#E10000;width:100px;height:25px;text-align:right;border-radius:3px">\n\
                                        <div style="background-color:#337AB7;width:' + percentage + '%;height:25px;border-radius:3px">\n\
                                            <div style="display: inline-block;background-color:black;width:0px;height:25px;margin-left:' + (percentage - 1) + 'px">\n\
                                            <span class="glyphicon glyphicon-time" style="font-size:20px;margin-top:5px;margin-left:-6px;color:white;z-index:50000"></span></div>\n\
                                        </div>\n\
                                        <div style="margin-top:-33px;margin-right:-18px;font-size:31px;color:#E10000"><span style="" class="glyphicon glyphicon-pause"></span></div>\n\
                                    </div>';
                } else {
                    var percentage = data.slaPercentage + 1;
                    if (percentage > 87) {
                        percentage = 87;
                    }
                    return '<div data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="sla.totalTime"/>:' + '&nbsp;' + data.slaValue + ',' + '&nbsp;' + data.difTimeString + '" style="background-color:#E10000;width:100px;height:25px;text-align:right;border-radius:3px">\n\
                                        <div style="background-color:#337AB7;width:' + percentage + '%;height:25px;border-radius:3px">\n\
                                            <div style="display: inline-block;background-color:black;width:0px;height:25px;margin-left:' + (percentage - 1) + 'px">\n\
                                            <span class="glyphicon glyphicon-time" style="font-size:20px;margin-top:5px;margin-left:-6px;color:white;z-index:50000"></span></div>\n\
                                        </div>\n\
                                        <div style="margin-top:-28px;margin-right:-17px;font-size:25px;color:#E10000"><span style="" class="glyphicon glyphicon-triangle-right"></span></div>\n\
                                    </div>';

                }

            } else if (data.slaPassed === "false") {
                if (data.statusId === "2") {
                    var percentage = data.slaPercentage + 1;
                    if (percentage > 87) {
                        percentage = 87;
                    }
                    return '<div data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="sla.totalTime"/>:' + '&nbsp;' + data.slaValue + ',' + '&nbsp;' + data.difTimeString + '" style="background-color:#B0DAFF;width:100px;height:25px;text-align:right;border-radius:3px">\n\
                                        <div style="background-color:#337AB7;width:' + percentage + '%;height:25px;border-radius:3px">\n\
                                            <div style="display: inline-block;background-color:black;width:0px;height:25px;margin-left:' + (percentage - 1) + 'px">\n\
                                            </div>\n\
                                        </div>\n\
                                        <div style="margin-top:-28px;margin-right:-12px;font-size:25px;color:#8eb1d0"><span class="glyphicon glyphicon-time"></span></div>\n\
                                    </div>';
                } else {
                    var percentage = data.slaPercentage + 1;
                    if (percentage > 81) {
                        percentage = 81;
                    }
                    return '<div data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="sla.totalTime"/>:' + '&nbsp;' + data.slaValue + ',' + '&nbsp;' + data.difTimeString + '" style="background-color:#B0DAFF;width:100px;height:25px;text-align:right;border-radius:3px">\n\
                                        <div style="background-color:#337AB7;width:' + percentage + '%;height:25px;border-radius:3px">\n\
                                            <div style="display: inline-block;background-color:black;width:0px;height:25px;margin-left:' + (percentage - 1) + 'px">\n\
                                            <span class="glyphicon glyphicon-triangle-right" style="font-size:25px;margin-top:5px;margin-left:-8px;color:#337AB7;"></span></div>\n\
                                        </div>\n\
                                        <div style="margin-top:-28px;margin-right:-12px;font-size:25px;color:#8eb1d0"><span class="glyphicon glyphicon-time"></span></div>\n\
                                    </div>';

                }
            } else if (data.slaPassed === "none-closed") {
                return '<div data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="ticket.slaNotDefined"/>' + '&nbsp;' + data.difTimeString + '" style="background-color:#337AB7;width:95px;height:25px;border-radius:3px">\n\
                                    <span  style="float:right;margin-top:4px;margin-right:-18px;font-size:31px;color:#337AB7" class="glyphicon glyphicon-pause"></span></div>';
            } else if (data.slaPassed === "none-open") {
                return '<div data-toggle="tooltip" data-placement="left" title="' + '<spring:message code="ticket.slaNotDefined"/>' + '&nbsp;' + data.difTimeString + '" style="background-color:#E10000;width:100px;height:25px;border-radius:3px">\n\
                                    <span  style="float:right;margin-top:5px;margin-right:-17px;font-size:25px;color:#E10000" class="glyphicon glyphicon-triangle-right"></span></div>';
            }
        }

        var userTable;

        var colorSet = new am4core.ColorSet();
        colorSet.list = ["#D32F2F", "#7CB342", "#9E9E9E", "#FFD54F", "#FF8F00", "#CDDC39", "#33691E", "#f1d18a", "#e6b31e", "#f1e58a"].map(function (color) {
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
        /* Çekilen datanın birden fazla grafikte kullanıldığı durumda tanımlanan değişkenler */
        var assetData;
        var dailyVulnCountData;
        var dailyRiskScoreData;
        var vulnLevelCountData;
        /* amChart  GRAFİK DEĞİŞKEN TANIMLAMALARI */
        var chart, riskEffectHeatmapGraph, smallRiskScoreGraph, vulnDayGraph, top10ipgraph, assetScore, assetScoreLegend, assetrisk, assetgroupsvuln, vulnDayGraphTotal, riskScoreGraph, riskScoreGraphByLevel;
        var riskLevelVulnGraph, effectgraph,cvegraph, top10kbgraph, rootcausegraph, portgraph, portservices, assetsbyassetgroup, assetsbyassetgroupLegend, operatingsystems, categorygraph, problemvulnerabilities, problemvulnerabilitiesLegend;
        var levelOpenClosedCountGraph, timegraph, totaltimegraph, totalManualAddedVulGraph, numberOfOpenVulnerabilitiesOnUserGraph, chartdiv, topTenWebAppVuln, heatMap, assetRiskDistGraph;
        var riskEffectHeatmapIndicator, chartIndicator, smallRiskScoreIndicator, topTenWebAppVulnIndicator, assetScoreIndicator, top10ipIndicator, assetriskIndicator;
        var assetgroupsvulnIndicator, vulnDayIndicator, riskLevelVulnIndicator, effectIndicator, rootcauseIndicator, portIndicator, top10kbIndicator, portservicesIndicator, operatingsystemsIndicator;
        var assetsbyassetgroupIndicator, categoryIndicator, problemvulnerabilitiesIndicator, levelOpenClosedCountIndicator, timeIndicator, totaltimeIndicator, totalManualAddedVulIndicator;
        var numberOfOpenVulnerabilitiesOnUserIndicator, riskScoreChangeChart, vulnDayGraphStatus, operatingSystemsLegend, userPerformanceChart, portservicesLegend;

        var riskScoreCursorChart, riskScoreCursorAxis2, riskScoreCursorRange0, riskScoreCursorRange1, riskScoreCursorLabel, riskScoreCursorHand;

        function sliderChanged(timeStamp) {
            blockUILoading();
            $.post("${context}/dashboard/getDashboardSnapshot.json", 
                {${_csrf.parameterName}: "${_csrf.token}",
                    "date": timeStamp}).done(function (result) {
                    if(result.length > 0) {
                        for (var i = 0; i < result.length; i++) {
                            switch (result[i].graphName) {
                               case 'dailyRiskLevelAndVulnCount.json':
                                    smallRiskScoreFunction(JSON.parse(decodeHtml(result[i].jsonData)));
                                    break;

                                case 'loadRiskReport.json':
                                    riskTable(JSON.parse(decodeHtml(result[i].jsonData)));
                                    break;

                                case 'vulnerabilityStatusCounts.json':
                                    vulnByStatusFunction(JSON.parse(decodeHtml(result[i].jsonData)));
                                    break;

                                case 'frequentWebAppVuln.json':
                                    topTenWebAppVulnFunction(JSON.parse(decodeHtml(result[i].jsonData)));
                                    break;

                                case 'loadTopTenAssets.json':
                                    showAssetTable(JSON.parse(decodeHtml(result[i].jsonData)));
                                    break;

                                case 'loadTopTenVulnerabilities.json':
                                    showVulnerabilityTable(JSON.parse(decodeHtml(result[i].jsonData)));
                                    break;

                                case 'riskEffectHeatmap.json':
                                    riskEffectHeatmapGraphFunction(JSON.parse(decodeHtml(result[i].jsonData)));
                                    break;

                                default:                               
                                    break;
                            }
                        }
                        document.getElementById("sliderDiv").style.width = "98%";
                        $(".leftFilter").css("display","none");     
                        $("#graphFilter").css("display","none");
                        $("#graphTabs").css("display","none");
                    } else {
                        document.getElementById("sliderDiv").style.width = "90%";
                        $(".leftFilter").css("display","block");
                        $("#graphFilter").css("display","block");
                        $("#showAll1").css("display","block");
                        $("#showAll2").css("display","block");
                        $("#graphTabs").css("display","block");
                        filterGraphs();
                    }
                    unBlockUILoading();
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
                unBlockUILoading();
            });
        }
        $(".page-content").on("click", "#graphFilter", function (e) {
            $(".leftFilter").css("display","block");
        });
        function riskTable(snapshot) {
            var obj = getObjectByForm("searchForm");
            if(snapshot !== undefined) {
                getRiskTableData(snapshot);
            } else {
                $.post("loadRiskReport.json", obj).done(function (result) {
                    getRiskTableData(result);
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                });
            }
        }
        
        function getRiskTableData(result) {
            var span = document.getElementById("riskGrade");
            span.title = span.title.toUpperCase();
            if (result.data.length === 0) {
                span.style.color = "#333";
                span.parentNode.parentNode.parentNode.style.cursor = "pointer";
                span.style.fontSize = "1.9vw";
                span.innerText = "-";
                span.parentNode.parentNode.parentNode.setAttribute("data-content", "");
                $('#popover_content').remove();
            } else {
                if(decodeHtml(result.data[0].totalGrade) === "A+"){
                    $('#riskGradeImg').attr("src", "${context}/resources/logo/riskGrade.png");
                } else if(result.data[0].totalGrade === "A"){
                    $('#riskGradeImg').attr("src", "${context}/resources/logo/riskGradeA.png");
                } else if(result.data[0].totalGrade === "B"){
                    $('#riskGradeImg').attr("src", "${context}/resources/logo/riskGradeB.png");
                } else if(result.data[0].totalGrade === "C"){
                    $('#riskGradeImg').attr("src", "${context}/resources/logo/riskGradeC.png");
                } else if(result.data[0].totalGrade === "D"){
                    $('#riskGradeImg').attr("src", "${context}/resources/logo/riskGradeD.png");
                } else if(result.data[0].totalGrade === "E"){
                    $('#riskGradeImg').attr("src", "${context}/resources/logo/riskGradeE.png");
                } else if(result.data[0].totalGrade === "F"){
                    $('#riskGradeImg').attr("src", "${context}/resources/logo/riskGradeF.png");
                } else {
                    $('#riskGradeImg').attr("src", "${context}/resources/logo/riskGradeZ.png");
                }
                span.style.color = decodeHtml(result.data[0].totalColor);
                span.style.cursor = "pointer";
                span.style.fontSize = "2.2vw";
                span.innerHTML = decodeHtml(result.data[0].totalGrade).bold();
                var table = document.createElement("table");
                table.style.width = "100%";
                table.style.border = "none";
                var tbody = document.createElement("tbody");
                for (var i = 0; i < result.data.length; i++) {
                    var tr = document.createElement("tr");

                    if (i === 0) {
                        var td1 = document.createElement("td");
                        td1.style.textAlign = "center";
                        td1.style.fontSize = "3.5vw";
                        td1.style.color = decodeHtml(result.data[0].totalColor);
                        td1.rowSpan = result.data.length;
                        td1.style.width = "30%";
                        td1.innerHTML = decodeHtml(result.data[0].totalGrade).bold();
                        var image = document.createElement("img");
                        if(decodeHtml(result.data[0].totalGrade) === "A+"){
                            image.src = "${context}/resources/logo/riskGrade.png";
                        } else if(result.data[0].totalGrade === "A"){
                            image.src = "${context}/resources/logo/riskGradeA.png";
                        } else if(result.data[0].totalGrade === "B"){
                            image.src = "${context}/resources/logo/riskGradeB.png";
                        } else if(result.data[0].totalGrade === "C"){
                            image.src = "${context}/resources/logo/riskGradeC.png";
                        } else if(result.data[0].totalGrade === "D"){
                            image.src = "${context}/resources/logo/riskGradeD.png";
                        } else if(result.data[0].totalGrade === "E"){
                            image.src = "${context}/resources/logo/riskGradeE.png";
                        } else if(result.data[0].totalGrade === "F"){
                            image.src = "${context}/resources/logo/riskGradeF.png";
                        } else {
                            image.src = "${context}/resources/logo/riskGradeZ.png";
                        }
                        td1.appendChild(image); 
                        tr.appendChild(td1);

                        var td2 = document.createElement("td");
                        td2.style.fontSize = "12px";
                        td2.style.width = "65%";
                        <c:choose>
                        <c:when test="${selectedLanguage == 'en'}">
                        var txt2 = document.createElement('div');
                        txt2.className = "riskGradeCategoryNameSmoothHeader";
                        txt2.textContent = decodeHtml(result.data[i].categoryEnglish);
                        </c:when>
                        <c:when test="${selectedLanguage == 'tr'}">
                        var txt2 = document.createElement('div');
                        txt2.className = "riskGradeCategoryNameSmoothHeader";
                        txt2.textContent = decodeHtml(result.data[i].category);
                        </c:when>
                        </c:choose>
                        td2.style.paddingTop = "5px";
                        td2.appendChild(txt2);
                        tr.appendChild(td2);

                        var td3 = document.createElement("td");
                        td3.style.fontSize = "12px";
                        td3.style.color = decodeHtml(result.data[i].color);
                        td3.style.width = "5%";
                        td3.style.paddingTop = "5px";
                        var txt3 = document.createElement('div');
                        txt3.style.border = "1px solid #2E353C";
                        txt3.style.borderRadius = "15px 15px 15px 15px";
                        txt3.style.backgroundColor = decodeHtml(result.data[i].color);
                        txt3.style.padding = "5px";
                        txt3.style.textAlign = "center";
                        txt3.style.color = "black";
                        txt3.style.marginLeft = "-20px";
                        txt3.style.overflowWrap = "inherit";
                        txt3.textContent = decodeHtml("&nbsp;&nbsp;" + result.data[i].grade + "&nbsp;&nbsp;");
                        td3.appendChild(txt3);
                        tr.appendChild(td3);
                    } else {
                        var td2 = document.createElement("td");
                        td2.style.fontSize = "12px";
                        td2.style.width = "65%";
                        td2.style.paddingTop = "5px";
    <c:choose>
        <c:when test="${selectedLanguage == 'en'}">
                        var txt2 = document.createElement('div');
                        txt2.className = "riskGradeCategoryNameSmoothHeader";
                        txt2.textContent = decodeHtml(result.data[i].categoryEnglish);
        </c:when>
        <c:when test="${selectedLanguage == 'tr'}">
                        var txt2 = document.createElement('div');
                        txt2.className = "riskGradeCategoryNameSmoothHeader";
                        txt2.textContent = decodeHtml(result.data[i].category);
        </c:when>
    </c:choose>
                        td2.appendChild(txt2);
                        tr.appendChild(td2);

                        var td3 = document.createElement("td");
                        td3.style.fontSize = "12px";
                        td3.style.color = decodeHtml(result.data[i].color);
                        td3.style.width = "5%";
                        td3.style.paddingTop = "5px";
                        var txt3 = document.createElement('div');
                        txt3.style.border = "1px solid #2E353C";
                        txt3.style.borderRadius = "15px 15px 15px 15px";
                        txt3.style.backgroundColor = decodeHtml(result.data[i].color);
                        txt3.style.padding = "5px";
                        txt3.style.textAlign = "center";
                        txt3.style.color = "black";
                        txt3.style.marginLeft = "-20px";
                        txt3.textContent = decodeHtml("&nbsp;&nbsp;" + result.data[i].grade + "&nbsp;&nbsp;");
                        td3.appendChild(txt3);
                        tr.appendChild(td3);
                    }
                    tbody.appendChild(tr);
                }
                table.appendChild(tbody);

               
                $('#popover_content').popover({ container: 'body' });
                $('#popover_content').html(table.outerHTML);  
                $('#popover_content').css('border','2px #2e353c solid');
                $('#popover_content').css('border-radius','10px');
                $('#popover_content').css('margin-top','10px');
            }
        }

        function topTables() {
            loadTableAsset('ten');
            loadTableVulnerability('ten');
        }

        var tempHeight = {};

        var viewAll = false;
        function fullScreenAlert() {
            if (document.getElementById("alertbox").style.height === "95%" && viewAll === false) {
                document.getElementById("alertbox").style.height = "100%";
                document.getElementsByClassName("slimScrollDiv")[0].style.height = $(window).height() + "px";
                tempHeight = document.getElementById("alarmTableDiv").style.height;
                document.getElementById("alarmTableDiv").style.height = "auto";
                document.getElementsByClassName("slimScrollDiv")[0].style.overflow = "auto";
                viewAll = true;
            } else {
                document.getElementById("alertbox").style.height = "95%";
                document.getElementsByClassName("slimScrollDiv")[0].style.height = "162px";
                document.getElementById("alarmTableDiv").style.height = tempHeight;
                document.getElementsByClassName("slimScrollDiv")[0].style.overflow = "hidden";
                viewAll = false;
            }
        }

        function getRiskScoreDiffFilterData(temp) {
            var level5;
            var level4;
            var level3;
            var level2;
            var level1;
            if(temp.length === 0 || temp[0].totalcount === 0) {
                level5 = 0;
                level4 = 0;
                level3 = 0;
                level2 = 0;
                level1 = 0;
            } else {
                level5 = temp[temp.length - 1].level5count;
                level4 = temp[temp.length - 1].level4count;
                level3 = temp[temp.length - 1].level3count;
                level2 = temp[temp.length - 1].level2count;
                level1 = temp[temp.length - 1].level1count;
            }
            $('#barLevel5').html(level5);
            $('#barLevel4').html(level4);
            $('#barLevel3').html(level3);
            $('#barLevel2').html(level2);
            $('#barLevel1').html(level1);
        }
        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER, ROLE_COMPANY_MANAGER_READONLY')">
            <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER')">
        function refreshDashboardGraphs() {
            $("#lastUpdateGraphContainer").html("<span style='color: #aeb2c4; font-size: 12px; font-weight: 600;'>" + "${lastUpdateDate}" + "<img src='${pageContext.request.contextPath}/resources/svg/oval.svg' style='height: 20px;'/></span>");
            $.post("${context}/dashboard/refreshDashboardGraphs.json", 
                {${_csrf.parameterName}: "${_csrf.token}"}).done(function (result) {
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            });
        }
            </sec:authorize>
        //-----------------------------------------------------     DASHBOARD SABİT GRAFİKLER     -----------------------------------------------------//
        function vulnByStatusFunction(snapshot) {
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#chartdiv").html();
            if (chartdiv !== undefined)
                chartdiv.dispose();
            /* Sabit Üst: ZAFİYET DURUMU GRAFİĞİ donutchart*/
            chartdiv = am4core.create("chartdiv", am4charts.PieChart3D);
            chartdiv.hiddenState.properties.opacity = 0; // this creates initial fade-in
            chartdiv.innerRadius = am4core.percent(40);
            chartdiv.depth = 20;
            
            // Add and configure Series
            var pieSeries = chartdiv.series.push(new am4charts.PieSeries3D());
            pieSeries.dataFields.value = "value";
            pieSeries.dataFields.category = "name";
            pieSeries.dataFields.depthValue = "value";
            pieSeries.innerRadius = am4core.percent(40);
            pieSeries.ticks.template.disabled = true;
            pieSeries.labels.template.disabled = true;
            pieSeries.slices.template.cornerRadius = 5;
            pieSeries.colors = colorSet;
            /*let rgm = new am4core.RadialGradientModifier();
             rgm.brightnesses.push(-0.6, -0.6, -0.3, 0, - 0.3);
             pieSeries.slices.template.fillModifier = rgm;
             pieSeries.slices.template.strokeModifier = rgm;
             pieSeries.slices.template.strokeOpacity = 0.4;
             pieSeries.slices.template.strokeWidth = 0;*/

            pieSeries.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            pieSeries.slices.template.interactionsEnabled = true;
            pieSeries.slices.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?statusValues=' + ev.target.dataItem.dataContext.status;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            },
                    this

                    );
            chartdiv.legend = new am4charts.Legend();
            var legendContainer = am4core.create("legenddiv", am4core.Container);
            legendContainer.width = am4core.percent(100);
            legendContainer.height = am4core.percent(100);
            chartdiv.legend.parent = legendContainer;
            chartdiv.legend.scale = 0.7;
            chartdiv.legend.fontSize = 12;
            chartdiv.legend.align = "center";
            
            chartDivIndicator = chartdiv.tooltipContainer.createChild(am4core.Container);
            chartDivIndicator.background.fill = am4core.color("#fff");
            chartDivIndicator.background.fillOpacity = 0.8;
            chartDivIndicator.width = am4core.percent(100);
            chartDivIndicator.height = am4core.percent(100);

            var chartDivIndicatorLabel = chartDivIndicator.createChild(am4core.Label);
            chartDivIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            chartDivIndicatorLabel.align = "center";
            chartDivIndicatorLabel.valign = "middle";
            chartDivIndicatorLabel.fontSize = 12;
            chartDivIndicator.hide();
             
            $('#donutchartWait').hide();
            $('#chartdiv').show();
             

            if(snapshot !== undefined) {
                getVulnByStatusData(snapshot);
            } else {
                $.post("vulnerabilityStatusCounts.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    getVulnByStatusData(temp);
                });
            }
        }
        function getVulnByStatusData(temp) {
            var combined = [];
            
            combined[0] = {"name": "<spring:message code="genericdb.OPEN"/>", "status": 'OPEN', "value": <c:out value = "temp[0]"/>};
            combined[1] = {"name": "<spring:message code="genericdb.CLOSED"/>", "status": 'CLOSED', "value": <c:out value = "temp[1]"/>};
            combined[2] = {"name": "<spring:message code="genericdb.RISK_ACCEPTED"/>", "status": 'RISK_ACCEPTED', "value": <c:out value = "temp[2]"/>};
            combined[3] = {"name": "<spring:message code="genericdb.RECHECK"/>", "status": 'RECHECK', "value": <c:out value = "temp[3]"/>};
           
            combined[4] = {"name": "<spring:message code="genericdb.ON_HOLD"/>", "status": 'ON_HOLD', "value": <c:out value = "temp[4]"/>};
            combined[5] = {"name": "<spring:message code="genericdb.IN_PROGRESS"/>", "status": 'IN_PROGRESS', "value": <c:out value = "temp[5]"/>};          
            combined[6] = {"name": "<spring:message code="genericdb.FALSE_POSITIVE"/>", "status": 'FALSE_POSITIVE', "value": <c:out value = "temp[6]"/>};
            
            

            $('#chartdiv').css("line-height", "");
            chartdiv.data = combined;
         }
        function getCountAssetAndVulnByRiskScoreData(temp) {
            var combined = [];
            var counter = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            obj = {};
            if (temp !== null) {
                for (var x = 0; x < temp.length; x++) {
                    var num = Math.floor(temp[x] / 10);
                    if(num === 10) {
                        counter[9]++;
                    } else {
                        counter[num]++;
                    }
                }
            }

            var isEmpty = true;
            for (var i = 0; i < counter.length; i++) {
                if (counter[i] !== 0)
                    isEmpty = false;
                var bubbleColor = calculateBubbleColor(i * 10 + 5);
                combined.push({"x": i * 10 + 5, "y": counter[i], "value": i * 10 + " - " + (i * 10 + 10), "color": bubbleColor});
            }
            if (isEmpty) {
                /* $('#countVulnByRiskScore').removeAttr('style');
                 $('#countVulnByRiskScore').css("text-align", "center");
                 $('#countVulnByRiskScore').css("width:", "100%");
                 $('#countVulnByRiskScore').css("height", "99%");
                 $('#countVulnByRiskScore').css("line-height", "99%");
                 $('#countVulnByRiskScore').text("<spring:message code="generic.emptyGraph"/>");*/
                countVulnByRiskScore.data = [];
                countVulnByRiskScoreIndicator.show();
            } else {
                $('#countVulnByRiskScore').css("line-height", "");
                countVulnByRiskScore.data = combined;
                countVulnByRiskScoreIndicator.hide();
                countVulnByRiskScore.paddingRight = 10;
                countVulnByRiskScore.paddingLeft = 10;
                countVulnByRiskScore.paddingTop = 10;
                countVulnByRiskScore.paddingBottom = 5;
            }
        }
        function calculateBubbleColor(value) {
            if (value > 90)
                color = "#800026";
            else if (value > 80)
                color = "#bd0026";
            else if (value > 70)
                color = "#e31a1c";
            else if (value > 60)
                color = "#fc4e2a";
            else if (value > 50)
                color = "#fd8d3c";
            else if (value > 40)
                color = "#feb24c";
            else if (value > 30)
                color = "#fed976";
            else if (value > 20)
                color = "#ffeda0";
            else if (value > 10)
                color = "#ffffcc";
            else
                color = "#cacaca";
            return color;
        }
        function topTenWebAppVulnFunction(snapshot) {        /////   VARLIK GRUPLARINA GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#topTenWebAppVuln").html();
            if (topTenWebAppVuln !== undefined)
                topTenWebAppVuln.dispose();
            /* Sabit Üst:  EN ÇOK KARŞILAŞILAN WEB UYGULAMA ZAFİYETLERİ*/
            topTenWebAppVuln = am4core.create("topTenWebAppVuln", am4charts.XYChart);
            // Create axes
            var categoryAxis = topTenWebAppVuln.yAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 30;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.label.horizontalCenter = "right";
            categoryAxis.tooltip.label.verticalCenter = "middle";
            categoryAxis.cursorTooltipEnabled = false;
            categoryAxis.renderer.inside = true;
            categoryAxis.renderer.labels.template.dy = -23;
            categoryAxis.renderer.labels.template.dx = 10;
            categoryAxis.renderer.grid.template.disabled = true;

            var label = categoryAxis.renderer.labels.template;
            //label.truncate = true;
            //label.maxWidth = 250;
            topTenWebAppVuln.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            var valueAxis = topTenWebAppVuln.xAxes.push(new am4charts.ValueAxis());
            valueAxis.cursorTooltipEnabled = false;

            // Create series
            var series = topTenWebAppVuln.series.push(new am4charts.ColumnSeries());
            series.dataFields.valueX = "value";
            series.dataFields.categoryY = "name";
            series.name = "value";
            series.tooltipText = "{categoryY}: [bold]{valueX}[/]";
            series.columns.template.fillOpacity = .8;
            series.columns.template.width = am4core.percent(50);
            series.columns.template.height = am4core.percent(50);
            series.columns.template.column.stroke = am4core.color("#fff");
            series.columns.template.column.strokeOpacity = 0.2;
            var columnTemplate = series.columns.template;

            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            columnTemplate.adapter.add("fill", function (fill, target) {
                return topTenWebAppVuln.colors.getIndex(target.dataItem.index);
            });

            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return topTenWebAppVuln.colors.getIndex(target.dataItem.index);
            });

            topTenWebAppVuln.cursor = new am4charts.XYCursor();
            topTenWebAppVuln.cursor.lineX.strokeOpacity = 0;
            topTenWebAppVuln.cursor.lineY.strokeOpacity = 0;
            topTenWebAppVuln.events.on("beforedatavalidated", function (ev) {
                topTenWebAppVuln.data.sort(function (a, b) {
                    return (a.value) - (b.value);
                });
            });
            series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.columns.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?vulnerabilityName=' + ev.target.dataItem.dataContext.name;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            },
                    this
                    );

            topTenWebAppVulnIndicator = topTenWebAppVuln.tooltipContainer.createChild(am4core.Container);
            topTenWebAppVulnIndicator.background.fill = am4core.color("#fff");
            topTenWebAppVulnIndicator.background.fillOpacity = 0;
            topTenWebAppVulnIndicator.width = am4core.percent(100);
            topTenWebAppVulnIndicator.height = am4core.percent(100);

            var topTenWebAppVulnIndicatorLabel = topTenWebAppVulnIndicator.createChild(am4core.Label);
            topTenWebAppVulnIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            topTenWebAppVulnIndicatorLabel.align = "center";
            topTenWebAppVulnIndicatorLabel.valign = "middle";
            topTenWebAppVulnIndicatorLabel.fontSize = 12;    
            topTenWebAppVulnIndicator.hide();         
            $('#topTenWebAppVulnWait').hide();
            $('#topTenWebAppVuln').show();

            if(snapshot !== undefined) {
                getTopTenWebAppVulnData(snapshot);
            } else {
                $.post("frequentWebAppVuln.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    getTopTenWebAppVulnData(temp);
                });
            }
        }
        function getTopTenWebAppVulnData(temp) {
            var combined = [];
            for (var i = 0; i < temp.length; i++) {
                combined.push({"name": decodeHtml(temp[i].name), "id": temp[i].kbItemId, "value": temp[i].count});
            }
            if (0 === combined.length) {
                topTenWebAppVuln.data = [];
                topTenWebAppVulnIndicator.show();
            } else {
                $('#topTenWebAppVuln').css("line-height", "");
                topTenWebAppVuln.data = combined;
                topTenWebAppVulnIndicator.hide();
            }        
        }
        function riskEffectHeatmapGraphFunction(snapshot) {
            $('#riskEffectHeatmapGraph').hide();
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#riskEffectHeatmapGraph").html();
            if (riskEffectHeatmapGraph !== undefined)
                riskEffectHeatmapGraph.dispose();
            riskEffectHeatmapGraph = am4core.create("riskEffectHeatmapGraph", am4charts.XYChart);
            riskEffectHeatmapGraph.preloader.disabled = false;
            var label = riskEffectHeatmapGraph.createChild(am4core.Label);
            label.text = "<spring:message code="dashboard.level3"/>";
            label.fontSize = 10;
            label.isMeasured = false;
            label.x = 0;
            label.y = 5;

            var label2 = riskEffectHeatmapGraph.createChild(am4core.Label);
            label2.text = "<spring:message code="dashboard.level1"/>";
            label2.fontSize = 10;
            label2.isMeasured = false;
            label2.x = 0;
            label2.y = 185;

            var gradient = new am4core.LinearGradient();
            gradient.addColor(am4core.color("#D91E18"));
            //gradient.addColor(am4core.color("#F88008"));
            gradient.addColor(am4core.color("#FEFE60"));
            gradient.addColor(am4core.color("#F9FABB"));

            gradient.rotation = 45;
            riskEffectHeatmapGraph.children.values[0].children.values[0].children.values[1].background.fill = gradient;
            var valueAxisX = riskEffectHeatmapGraph.xAxes.push(new am4charts.ValueAxis());
            valueAxisX.renderer.ticks.template.disabled = true;
            valueAxisX.renderer.axisFills.template.disabled = true;
            valueAxisX.min = 0;
            valueAxisX.max = 100;
            valueAxisX.strictMinMax = true; 
            valueAxisX.renderer.minGridDistance = 40;
            valueAxisX.renderer.inversed = true;
            var valueAxisY = riskEffectHeatmapGraph.yAxes.push(new am4charts.ValueAxis());
            valueAxisY.renderer.ticks.template.disabled = true;
            valueAxisY.renderer.axisFills.template.disabled = true;
            valueAxisY.renderer.labels.template.disabled = true;
            valueAxisY.min = 0;
            valueAxisY.max = 10.5;
            valueAxisY.strictMinMax = true; 
 
            /*valueAxisX.title.text = "<spring:message code="dashboard.riskScoreName"/>";
             valueAxisX.title.dy = -50;
             valueAxisX.paddingBottom = 0;*/
            var label3 = riskEffectHeatmapGraph.createChild(am4core.Label);
            label3.text = "<spring:message code="dashboard.riskScoreName"/>";
            label3.fontSize = 10;
            label3.isMeasured = false;
            label3.x = am4core.percent(50);
            label3.y = 185;
            valueAxisY.title.text = "<spring:message code="listVulnerabilities.effect"/>";
            var series = riskEffectHeatmapGraph.series.push(new am4charts.LineSeries());
            series.dataFields.valueX = "riskScore";
            series.dataFields.valueY = "effect";
            series.dataFields.value = "value";
            series.strokeOpacity = 0;
            series.sequencedInterpolation = true;
            series.tooltip.pointerOrientation = "vertical";

            var bullet = series.bullets.push(new am4charts.CircleBullet());
            bullet.fill = am4core.color("#000000");
            bullet.propertyFields.fill = "#000000";
            bullet.strokeOpacity = 0;
            bullet.strokeWidth = 2;
            bullet.fillOpacity = 0.8;
            bullet.stroke = am4core.color("#ffffff");
            bullet.hiddenState.properties.opacity = 0;

            var outline = riskEffectHeatmapGraph.plotContainer.createChild(am4core.Circle);
            outline.fillOpacity = 0;
            outline.strokeOpacity = 0.8;
            outline.stroke = am4core.color("#ff0000");
            outline.strokeWidth = 2;
            outline.hide(0);

            var blurFilter = new am4core.BlurFilter();
            outline.filters.push(blurFilter);

            bullet.events.on("over", function (event) {
                var target = event.target;
                valueAxisX.tooltip.disabled = false;
                valueAxisY.tooltip.disabled = false;

                outline.radius = target.circle.pixelRadius + 2;
                outline.x = target.pixelX;
                outline.y = target.pixelY;
                outline.show();
            });

            bullet.events.on("out", function (event) {
                valueAxisX.tooltip.disabled = true;
                valueAxisY.tooltip.disabled = true;
                outline.hide();
            });

            var hoverState = bullet.states.create("hover");
            hoverState.properties.fillOpacity = 1;
            hoverState.properties.strokeOpacity = 1;

            series.heatRules.push({target: bullet.circle, min: 3, max: 10, property: "radius"});

            bullet.circle.adapter.add("tooltipY", function (tooltipY, target) {
                return -target.radius;
            });


            riskEffectHeatmapIndicator = riskEffectHeatmapGraph.tooltipContainer.createChild(am4core.Container);
            riskEffectHeatmapIndicator.background.fill = am4core.color("#fff");
            riskEffectHeatmapIndicator.background.fillOpacity = 0.8;
            riskEffectHeatmapIndicator.width = am4core.percent(100);
            riskEffectHeatmapIndicator.height = am4core.percent(100);
            riskEffectHeatmapGraph.maxZoomLevel = 1;
            riskEffectHeatmapGraph.seriesContainer.draggable = false;
            riskEffectHeatmapGraph.seriesContainer.resizable = false;
            var riskEffectHeatmapIndicatorLabel = riskEffectHeatmapIndicator.createChild(am4core.Label);
            riskEffectHeatmapIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            riskEffectHeatmapIndicatorLabel.align = "center";
            riskEffectHeatmapIndicatorLabel.valign = "middle";
            riskEffectHeatmapIndicatorLabel.fontSize = 12;
            /* Sabit Üst: ASSET RİSK DAĞILIM GRAFİĞİ*/

            $("#assetRiskDistGraphContainer").html();
            if (assetRiskDistGraph !== undefined)
                assetRiskDistGraph.dispose();
            assetRiskDistGraph = am4core.create("assetRiskDistGraphContainer", am4charts.XYChart);
            assetRiskDistGraph.hiddenState.properties.opacity = 0; // this creates initial fade-in

            assetRiskDistGraph.maskBullets = false;

            var xAxis = assetRiskDistGraph.xAxes.push(new am4charts.CategoryAxis());
            var yAxis = assetRiskDistGraph.yAxes.push(new am4charts.CategoryAxis());
            yAxis.renderer.inversed = true;
            xAxis.dataFields.category = "x";
            yAxis.dataFields.category = "y";

            xAxis.renderer.grid.template.disabled = true;
            xAxis.renderer.minGridDistance = 40;

            yAxis.renderer.grid.template.disabled = true;
            yAxis.renderer.inversed = false;
            valueAxisX.renderer.inversed = true;
            yAxis.renderer.minGridDistance = 30;
            //yAxis.renderer.labels.template.rotation = 270;
            yAxis.renderer.labels.template.dy = 30;
            yAxis.renderer.labels.dy = 30;
            var label = assetRiskDistGraph.createChild(am4core.Label);
            yAxis.title.text = "<spring:message code="dashboard.assetRiskSeverity"/>";
            xAxis.title.text = "<spring:message code="dashboard.vulnerabilityRiskLevel"/>";
            /*label.text = "<spring:message code="dashboard.assetRiskSeverity"/>";
             label.fontSize = 10;
             label.isMeasured = false;
             label.x = 0;
             label.y = 0;*/

            var series = assetRiskDistGraph.series.push(new am4charts.ColumnSeries());
            series.dataFields.categoryX = "x";
            series.dataFields.categoryY = "y";
            series.dataFields.value = "value";
            series.sequencedInterpolation = true;
            series.defaultState.transitionDuration = 3000;

            // Set up column appearance
            var column = series.columns.template;
            column.strokeWidth = 2;
            column.strokeOpacity = 1;
            column.stroke = am4core.color("#ffffff");
            column.tooltipText = "{x}, {y}: {value.workingValue.formatNumber('#.')}";
            column.width = am4core.percent(100);
            column.height = am4core.percent(100);
            column.column.cornerRadius(6, 6, 6, 6);
            column.propertyFields.fill = "color";

            // Set up bullet appearance
            /*var bullet1 = series.bullets.push(new am4charts.CircleBullet());
             bullet1.circle.propertyFields.radius = "value";
             bullet1.circle.fill = am4core.color("#000");
                     
             bullet1.circle.strokeWidth = 0;
             bullet1.circle.fillOpacity = 0.7;
             bullet1.circle.radius.max = 33;
             bullet1.interactionsEnabled = false;*/

            var bullet = series.bullets.push(new am4charts.CircleBullet());
            bullet.circle.strokeWidth = 0;
            bullet.circle.fill = am4core.color("#000");
            bullet.circle.fillOpacity = 0.7;
            series.heatRules.push({
                target: bullet.circle,
                min: 10,
                max: 33,
                property: "radius"
            });
            var bullet2 = series.bullets.push(new am4charts.LabelBullet());
            bullet2.label.text = "{value}";
            bullet2.label.fill = am4core.color("#fff");
            bullet2.zIndex = 1;
            bullet2.fontSize = 11;
            bullet2.interactionsEnabled = false;
            
            assetRiskDistGraphIndicator = assetRiskDistGraph.tooltipContainer.createChild(am4core.Container);
            assetRiskDistGraphIndicator.background.fill = am4core.color("#fff");
            assetRiskDistGraphIndicator.background.fillOpacity = 0.8;
            assetRiskDistGraphIndicator.width = am4core.percent(100);
            assetRiskDistGraphIndicator.height = am4core.percent(100);

            var assetRiskDistGraphIndicatorLabel = assetRiskDistGraphIndicator.createChild(am4core.Label);
            assetRiskDistGraphIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            assetRiskDistGraphIndicatorLabel.align = "center";
            assetRiskDistGraphIndicatorLabel.valign = "middle";
            assetRiskDistGraphIndicatorLabel.fontSize = 12;

            if(snapshot !== undefined) {
                getRiskEffectHeatmapGraphData(snapshot);
            } else {
                $.post("riskEffectHeatmap.json", obj).done(function (result) {
                    temp = result;
                    assetRiskDistGraphIndicator.hide();              
                    $('#assetRiskDistGraphWait').hide();
                    $('#assetRiskDistGraph').show();
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    getRiskEffectHeatmapGraphData(temp);
                });
            }
        }
        function getRiskEffectHeatmapGraphData(temp) {
            var combined = [];
            var combinedAssetRiskHeatmap = [];
            var lowAsset = [0, 0, 0, 0, 0];
            var mediumAsset = [0, 0, 0, 0, 0];
            var highAsset = [0, 0, 0, 0, 0];
            var map = new Object();
            for (var s = 0; s < temp.length; s++) {
                if (<c:out value ="temp[s].assetSeverity"/> === 'LOW')
                    lowAsset[<c:out value ="temp[s].riskLevel"/> - 1]++;
                else if (<c:out value ="temp[s].assetSeverity"/> === 'MEDIUM')
                    mediumAsset[<c:out value ="temp[s].riskLevel"/> - 1]++;
                else if (<c:out value ="temp[s].assetSeverity"/> === 'HIGH')
                    highAsset[<c:out value ="temp[s].riskLevel"/> - 1]++;
                var intRiskScore = Math.ceil(parseFloat(<c:out value ="temp[s].riskScore"/>));
                var mapStr = intRiskScore + "-" + <c:out value = "temp[s].effect"/>;
                if(map[mapStr] === undefined) {
                    map[mapStr] = 1;
                } else {
                    map[mapStr] = map[mapStr] + 1;
                }
            }
            var count = 0;
            for (var key in map) {
                combined[count] = {"riskScore": key.toString().split("-")[0], "effect": key.split("-")[1], "value": map[key]};
                count++;
            }

            if (0 === combined.length) {
                $('#riskEffectHeatmapGraph').removeAttr('style');
                $('#riskEffectHeatmapGraph').css("text-align", "center");
                $('#riskEffectHeatmapGraph').css("width:", "100%");
                $('#riskEffectHeatmapGraph').css("height", "240px");
                $('#riskEffectHeatmapGraph').css("line-height", "240px");
                $('#riskEffectHeatmapGraph').text("<spring:message code="generic.emptyGraph"/>");
                riskEffectHeatmapGraph.data = [];
                riskEffectHeatmapIndicator.hide();
                $('#riskEffectHeatmapGraphWait').hide();
                $('#riskEffectHeatmapGraph').show();
                //riskEffectHeatmapIndicator.show();
            } else {
                riskEffectHeatmapGraph.data = combined;
                $('#riskEffectHeatmapGraph').css("width", "100%");
                $('#riskEffectHeatmapGraph').css("height", "240px");
                $('#riskEffectHeatmapGraph').show();
                riskEffectHeatmapIndicator.hide();
                $('#riskEffectHeatmapGraphWait').hide();
                $('#riskEffectHeatmapGraph').show();
                riskEffectHeatmapGraph.paddingRight = 10;
                riskEffectHeatmapGraph.paddingLeft = 10;
                riskEffectHeatmapGraph.paddingTop = 0;
                riskEffectHeatmapGraph.paddingBottom = 5;
            }
            combinedAssetRiskHeatmap[0] = {"y": "<spring:message code="dashboard.level1"/>", "x": "<spring:message code="dashboard.level1"/>", "color": "#F9FABB", "value": lowAsset[0]};
            combinedAssetRiskHeatmap[1] = {"y": "<spring:message code="dashboard.level1"/>", "x": "<spring:message code="dashboard.level2"/>", "color": "#F9FABB", "value": lowAsset[1]};
            combinedAssetRiskHeatmap[2] = {"y": "<spring:message code="dashboard.level1"/>", "x": "<spring:message code="dashboard.level3"/>", "color": "#FEFE60", "value": lowAsset[2]};
            combinedAssetRiskHeatmap[3] = {"y": "<spring:message code="dashboard.level1"/>", "x": "<spring:message code="dashboard.level4"/>", "color": "#F8C508", "value": lowAsset[3]};
            combinedAssetRiskHeatmap[4] = {"y": "<spring:message code="dashboard.level1"/>", "x": "<spring:message code="dashboard.level5"/>", "color": "#F88008", "value": lowAsset[4]};
            combinedAssetRiskHeatmap[5] = {"y": "<spring:message code="dashboard.level2"/>", "x": "<spring:message code="dashboard.level1"/>", "color": "#F9FABB", "value": mediumAsset[0]};
            combinedAssetRiskHeatmap[6] = {"y": "<spring:message code="dashboard.level2"/>", "x": "<spring:message code="dashboard.level2"/>", "color": "#FEFE60", "value": mediumAsset[1]};
            combinedAssetRiskHeatmap[7] = {"y": "<spring:message code="dashboard.level2"/>", "x": "<spring:message code="dashboard.level3"/>", "color": "#F8C508", "value": mediumAsset[2]};
            combinedAssetRiskHeatmap[8] = {"y": "<spring:message code="dashboard.level2"/>", "x": "<spring:message code="dashboard.level4"/>", "color": "#F88008", "value": mediumAsset[3]};
            combinedAssetRiskHeatmap[9] = {"y": "<spring:message code="dashboard.level2"/>", "x": "<spring:message code="dashboard.level5"/>", "color": "#F80812", "value": mediumAsset[4]};
            combinedAssetRiskHeatmap[10] = {"y": "<spring:message code="dashboard.level3"/>", "x": "<spring:message code="dashboard.level1"/>", "color": "#FEFE60", "value": highAsset[0]};
            combinedAssetRiskHeatmap[11] = {"y": "<spring:message code="dashboard.level3"/>", "x": "<spring:message code="dashboard.level2"/>", "color": "#F8C508", "value": highAsset[1]};
            combinedAssetRiskHeatmap[12] = {"y": "<spring:message code="dashboard.level3"/>", "x": "<spring:message code="dashboard.level3"/>", "color": "#F88008", "value": highAsset[2]};
            combinedAssetRiskHeatmap[13] = {"y": "<spring:message code="dashboard.level3"/>", "x": "<spring:message code="dashboard.level4"/>", "color": "#F80812", "value": highAsset[3]};
            combinedAssetRiskHeatmap[14] = {"y": "<spring:message code="dashboard.level3"/>", "x": "<spring:message code="dashboard.level5"/>", "color": "#F80812", "value": highAsset[4]};

            /*combinedAssetRiskHeatmap[0] = {"category": "assetLow", "value1": lowAsset[0], "value2": lowAsset[1], "value3": lowAsset[2], "value4": lowAsset[3], "value5": lowAsset[4]};
             combinedAssetRiskHeatmap[1] = {"category": "assetMedium", "value1": mediumAsset[0], "value2": mediumAsset[1], "value3": mediumAsset[2], "value4": mediumAsset[3], "value5": mediumAsset[4]};
             combinedAssetRiskHeatmap[2] = {"category": "assetHigh", "value1": highAsset[0], "value2": highAsset[1], "value3": highAsset[2], "value4": highAsset[3], "value5": highAsset[4]};
             */
            //Asset Risk grafiği
            if (lowAsset[0] === 0 && lowAsset[1] === 0 && lowAsset[2] === 0 && lowAsset[3] === 0 && lowAsset[4] === 0
                    && mediumAsset[0] === 0 && mediumAsset[1] === 0 && mediumAsset[2] === 0 && mediumAsset[3] === 0 && mediumAsset[4] === 0
                    && highAsset[0] === 0 && highAsset[1] === 0 && highAsset[2] === 0 && highAsset[3] === 0 && highAsset[4] === 0) {
                $('#assetRiskDistGraphContainer').removeAttr('style');
                $('#assetRiskDistGraphContainer').css("text-align", "center");
                $('#assetRiskDistGraphContainer').css("width:", "100%");
                $('#assetRiskDistGraphContainer').css("height", "250px");
                $('#assetRiskDistGraphContainer').css("line-height", "250px");
                $('#assetRiskDistGraphContainer').text("<spring:message code="generic.emptyGraph"/>");
                assetRiskDistGraph.data = [];
            } else {
                assetRiskDistGraph.data = combinedAssetRiskHeatmap;
                $('#assetRiskDistGraph').css("width", "100%");
                $('#assetRiskDistGraph').css("height", "250px");
                $('#assetRiskDistGraph').show();
                assetRiskDistGraph.paddingRight = 10;
                assetRiskDistGraph.paddingLeft = 10;
                assetRiskDistGraph.paddingTop = 0;
                assetRiskDistGraph.paddingBottom = 0;
            }
        }
        function smallRiskScoreFunction(snapshot) {       // KÜÇÜK RİSK SKORU GRAFİĞİ
            $('#smallRiskScoreWait').show();
            $('#smallRiskScoreGraph').hide();
            var obj = getObjectByForm("searchForm");
            var timeInterval = $("label[for='options'].active")[0].firstElementChild.defaultValue;
            obj["timeInterval"] = timeInterval;
            var temp;
            if (smallRiskScoreGraph === null || smallRiskScoreGraph === undefined) {
                smallRiskScoreGraph = am4core.create("smallRiskScoreGraph", am4charts.XYChart);
            <c:choose>
                <c:when test="${selectedLanguage == 'en'}">
                </c:when>
                <c:when test="${selectedLanguage == 'tr'}">
                smallRiskScoreGraph.language.locale = am4lang_tr_TR;
                </c:when>
            </c:choose>
                smallRiskScoreGraph.paddingRight = 20;
                smallRiskScoreGraph.height = 250;
                smallRiskScoreGraph.dateFormatter.dateFormat = "yyyy-MMM-dd";

                // Create axes
                var dateAxis = smallRiskScoreGraph.xAxes.push(new am4charts.DateAxis());
                dateAxis.dataFields.category = "day";
                dateAxis.dateFormatter = new am4core.DateFormatter();
                dateAxis.dateFormats.setKey("month", "yyyy-MMM-dd");
                dateAxis.periodChangeDateFormats.setKey("month", "yyyy-MMM-dd");
                dateAxis.dateFormatter.dateFormat = "yyyy-MMM-dd";
                dateAxis.startLocation = 0.5;
                dateAxis.endLocation = 0.5;

                // Create series
                function createsmallRiskScoreGraphAxisAndSeries(field, name, opposite, bullet) {
                    var valueAxis = smallRiskScoreGraph.yAxes.push(new am4charts.ValueAxis());

                    var series = smallRiskScoreGraph.series.push(new am4charts.LineSeries());
                    series.dataFields.valueY = field;
                    series.dataFields.dateX = "day";
                    series.strokeWidth = 2;
                    series.yAxis = valueAxis;
                    series.name = name;
                    series.tooltipText = "{name}: [bold]{valueY}[/]";
                    series.tensionX = 0.8;
                    series.tooltip.getFillFromObject = false;
                    if (field === 'riskPoint') {
                        series.stroke = am4core.color("#456173");
                        valueAxis.renderer.line.stroke = am4core.color("#456173");
                        valueAxis.renderer.labels.template.fill = am4core.color("#456173");
                        series.tooltip.background.fill = am4core.color("#456173");
                    } else if (field === 'riskPoint2') {
                        series.tooltip.background.fill = am4core.color("#BD0026");
                        valueAxis.renderer.line.stroke = am4core.color("#BD0026");
                        valueAxis.renderer.labels.template.fill = am4core.color("#BD0026");
                        series.stroke = am4core.color("#BD0026");
                    }
                    valueAxis.renderer.line.strokeOpacity = 1;
                    valueAxis.renderer.line.strokeWidth = 2;
                    valueAxis.tooltip.disabled = true;
                    valueAxis.renderer.opposite = opposite;
                    valueAxis.renderer.grid.template.disabled = true;
                }

                createsmallRiskScoreGraphAxisAndSeries("riskPoint", "<spring:message code="main.theme.vulnCount"/>", false, "circle");
                createsmallRiskScoreGraphAxisAndSeries("riskPoint2", "<spring:message code="dashboard.riskScoreName"/>", true, "triangle");

                // Add legend
                //smallRiskScoreGraph.legend = new am4charts.Legend();

                // Add cursor
                smallRiskScoreGraph.cursor = new am4charts.XYCursor();


                smallRiskScoreIndicator = smallRiskScoreGraph.tooltipContainer.createChild(am4core.Container);
                smallRiskScoreIndicator.background.fill = am4core.color("#fff");
                smallRiskScoreIndicator.background.fillOpacity = 0.8;
                smallRiskScoreIndicator.width = am4core.percent(100);
                smallRiskScoreIndicator.height = am4core.percent(100);

                var smallRiskScoreIndicatorLabel = smallRiskScoreIndicator.createChild(am4core.Label);
                smallRiskScoreIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
                smallRiskScoreIndicatorLabel.align = "center";
                smallRiskScoreIndicatorLabel.valign = "middle";
                smallRiskScoreIndicatorLabel.fontSize = 12;
            }
            if(snapshot !== undefined) {
                dailyRiskScoreData = snapshot;
                dailyVulnCountData = snapshot;
                vulnLevelCountData = snapshot;
                getRiskScoreDiffFilterData(snapshot);
                riskScoreChangeFunction(snapshot);
                getSmallRiskScoreData(snapshot);              
            } else {
                $.post("dailyRiskLevelAndVulnCount.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    dailyRiskScoreData = temp;
                    dailyVulnCountData = temp;
                    vulnLevelCountData = temp;
                    getRiskScoreDiffFilterData(temp);
                    riskScoreChangeFunction(temp);
                    getSmallRiskScoreData(temp);
                });
            }
        }
        function getSmallRiskScoreData(temp) {
            var combinedtimegraph = [];
            var allZero = true;
            for (var s = 0; s < temp.length; s++) {
                if (temp[s].totalcount !== 0)
                    allZero = false;
                combinedtimegraph[s] = {"day": new Date(<c:out value = "temp[s].date"/>), 
                    "riskPoint": <c:out value ="temp[s].totalcount"/>, 
                    "riskPoint2": <c:out value = "temp[s].totalriskPoint"/>,
                    "lineColor": "#ff0000"};
            }
            if (allZero) {
                $('#smallRiskScoreWait').hide();
                /* $('#smallRiskScoreGraph').removeAttr('style');
                 $('#smallRiskScoreGraph').css("text-align", "center");
                 $('#smallRiskScoreGraph').css("width:", "100%");
                 $('#smallRiskScoreGraph').css("height", "100px");
                 $('#smallRiskScoreGraph').css("line-height", "100px");
                 $('#smallRiskScoreGraph').text("<spring:message code="generic.emptyGraph"/>");*/
                smallRiskScoreGraph.data = [];
                smallRiskScoreIndicator.show();
            } else {
                smallRiskScoreGraph.data = combinedtimegraph;
                $('#smallRiskScoreGraph').css("width", "100%");
                $('#smallRiskScoreGraph').css("height", "250px");
                $('#smallRiskScoreWait').hide();
                $('#smallRiskScoreGraph').show();
                smallRiskScoreIndicator.hide();
            }
        }     
        function riskScoreChangeFunction(temp){
            var today;
            var yesterday;
            var lastWeek;
            var lastMonth;
            if(temp.length === 0 || temp[0].totalcount === 0){
                today = 0;
                yesterday = 0;
                lastWeek = 0;
                lastMonth = 0;
            } else {
                if(temp.length > 0){
                    today = temp[0].today;
                    yesterday = temp[0].yesterday;
                    lastWeek = temp[0].lastWeek;
                    lastMonth = temp[0].lastMonth;
                } else {
                    today = 0;
                    yesterday = 0;
                    lastWeek = 0;
                    lastMonth = 0;
                }
                
            }
            var riskScoreDiff;
            $("#riskScoreToday").text(today);
            $("#riskScoreToday").css("font-weight", "bold");
            $("#riskScoreToday").css("font-size", "12px");
            if(yesterday > today){
                $("#riskScoreYesterday").text(yesterday);
                $("#riskScoreYesterday").css("color", "rgba(207, 0, 15, 1)");
                $("#riskScoreYesterday").css( "font-weight" , "bold");
                $("#riskScoreYesterday").css("font-size", "12px");
                riskScoreDiff = today - yesterday;
                $("#riskScoreDiffYesterday").text( riskScoreDiff);
                $("#riskScoreDiffYesterday").css("color", "rgba(0, 230, 64, 1)");
                $("#riskScoreDiffYesterday").css("font-size", "12px");
                $("#circleYesterday").html('<i class="fas fa-arrow-circle-down" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');}
            else if(yesterday === today){
                $("#riskScoreYesterday").text(yesterday);
                $("#riskScoreYesterday").css("font-weight", "bold");
                $("#riskScoreYesterday").css("font-size", "12px");
                riskScoreDiff = today - yesterday;
                $("#riskScoreDiffYesterday").text(riskScoreDiff);
                $("#riskScoreDiffYesterday").css("font-size", "12px");
                $("#circleYesterday").html('<i class="fas fa-arrow-circle-right" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');}
            else{
                $("#riskScoreYesterday").text(yesterday);
                $("#riskScoreYesterday").css("color", "rgba(0, 230, 64, 1)");
                $("#riskScoreYesterday").css("font-weight", "bold");
                $("#riskScoreYesterday").css("font-size", "12px");
                riskScoreDiff = today - yesterday;
                $("#riskScoreDiffYesterday").text(riskScoreDiff);
                $("#riskScoreDiffYesterday").css("color", "rgba(207, 0, 15, 1)");
                $("#riskScoreDiffYesterday").css("font-size", "12px");
                $("#circleYesterday").html('<i class="fas fa-arrow-circle-up" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>');}
            
            if(lastWeek > today){
                $("#riskScoreLastWeek").text(lastWeek);
                $("#riskScoreLastWeek").css("color", "rgba(207, 0, 15, 1)");
                $("#riskScoreLastWeek").css("font-weight", "bold");
                $("#riskScoreLastWeek").css("font-size", "12px");
                riskScoreDiff = today - lastWeek;
                $("#riskScoreDiffLastWeek").text(riskScoreDiff);
                $("#riskScoreDiffLastWeek").css("color", "rgba(0, 230, 64, 1)");
                $("#riskScoreDiffLastWeek").css("font-size", "12px");
                $("#circleLastWeek").html('<i class="fas fa-arrow-circle-down" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');}
            else if(lastWeek === today){
                $("#riskScoreLastWeek").text(lastWeek);
                $("#riskScoreLastWeek").css("font-weight", "bold");
                $("#riskScoreLastWeek").css("font-size", "12px");
                riskScoreDiff = today - lastWeek;
                $("#riskScoreDiffLastWeek").text(riskScoreDiff);
                $("#riskScoreDiffLastWeek").css("font-size", "12px");
                $("#circleLastWeek").html('<i class="fas fa-arrow-circle-right" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');}
            else{
                $("#riskScoreLastWeek").text(lastWeek);
                $("#riskScoreLastWeek").css("color", "rgba(0, 230, 64, 1)");
                $("#riskScoreLastWeek").css("font-weight", "bold");
                $("#riskScoreLastWeek").css("font-size", "12px");
                riskScoreDiff = today - lastWeek;
                $("#riskScoreDiffLastWeek").text(riskScoreDiff);
                $("#riskScoreDiffLastWeek").css("color", "rgba(207, 0, 15, 1)");
                $("#riskScoreDiffLastWeek").css("font-size", "12px");
                $("#circleLastWeek").html('<i class="fas fa-arrow-circle-up" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>');}
            
            if(lastMonth > today){
                $("#riskScoreLastMonth").text(lastMonth);
                $("#riskScoreLastMonth").css("color", "rgba(207, 0, 15, 1)");
                $("#riskScoreLastMonth").css( "font-weight", "bold");
                $("#riskScoreLastMonth").css("font-size", "12px");
                riskScoreDiff = today - lastMonth;
                $("#riskScoreDiffLastMonth").text(riskScoreDiff);
                $("#riskScoreDiffLastMonth").css("color", "rgba(0, 230, 64, 1)");
                $("#riskScoreDiffLastMonth").css("font-size", "12px");
                $("#circleLastMonth").html('<i class="fas fa-arrow-circle-down" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(0, 230, 64, 1)"></i>');}
            else if(lastMonth === today){
                $("#riskScoreLastMonth").text(lastMonth);
                $("#riskScoreLastMonth").css("font-weight", "bold");
                $("#riskScoreLastMonth").css("font-size", "12px");
                riskScoreDiff = today - lastMonth;
                $("#riskScoreDiffLastMonth").text(riskScoreDiff);
                $("#riskScoreDiffLastMonth").css("font-size", "12px");
                 $("#circleLastMonth").html('<i class="fas fa-arrow-circle-right" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(0, 75, 155, 0.7)"></i>');}
            else{
                $("#riskScoreLastMonth").text(lastMonth);
                $("#riskScoreLastMonth").css("color", "rgba(0, 230, 64, 1)");
                $("#riskScoreLastMonth").css( "font-weight", "bold");
                $("#riskScoreLastMonth").css("font-size", "12px");
                riskScoreDiff = today - lastMonth;
                $("#riskScoreDiffLastMonth").text(riskScoreDiff);
                $("#riskScoreDiffLastMonth").css("color", "rgba(207, 0, 15, 1)");
                $("#riskScoreDiffLastMonth").css("font-size", "12px");
                $("#circleLastMonth").html('<i class="fas fa-arrow-circle-up" style="font-size:12px;float:inherit;margin-right: 10px;color:rgba(207, 0, 15, 1)"></i>');}
            
            $('#riskScoreChangeChartWait').hide();
                                                   
		if(temp.length !== 0 && temp[0].totalcount !== 0){
                var todaysRiskScore = temp[0].today;
                $('#todaysRiskScore').text(todaysRiskScore); 
                var percentage = ${actionScore} * 100 / ${totalScore};
                var barScore = ((91* percentage) / 100);
                $('#scoreBarProgress').css("width", barScore + "%");
            } else {
                $('#todaysRiskScore').text("-"); 
            }
          
           
            
        }
        </sec:authorize>
        //-----------------------------------------------------//
        function setListScans() {
            localStorage.setItem("activeScan", true);
            window.open("../pentest/listScans.htm", '_blank');
        }
        function showAssetTable(snapshot) {
            $('#top10AssetTable').DataTable().clear();
            $('#top10AssetTable').DataTable().destroy();
            loadTableAsset('ten', snapshot);
            $("#showAll1").text(decodeHtml("<spring:message code="dashboard.showAll"/>"));
            $("#showAll1").css("display","none");
        }
        function showAllAsset() {
            if (countAss % 2 === 0) {
                $('#top10AssetTable').DataTable().clear();
                $('#top10AssetTable').DataTable().destroy();
                loadTableAsset('all');
                $("#showAll1").text(decodeHtml("<spring:message code="dashboard.tenAssets"/>"));
                countAss++;
            } else {
                $('#top10AssetTable').DataTable().clear();
                $('#top10AssetTable').DataTable().destroy();
                loadTableAsset('ten');
                $("#showAll1").text(decodeHtml("<spring:message code="dashboard.showAll"/>"));
                countAss++;
            }
        }
        function showVulnerabilityTable(snapshot) {
            $('#top10VulnTable').DataTable().clear();
            $('#top10VulnTable').DataTable().destroy();
            loadTableVulnerability('ten', snapshot);
            $("#showAll2").text(decodeHtml("<spring:message code="dashboard.showAll"/>"));
            $("#showAll2").css("display","none");
        }
        function showAllVulnerability() {
            if (count % 2 === 0) {
                $('#top10VulnTable').DataTable().clear();
                $('#top10VulnTable').DataTable().destroy();
                loadTableVulnerability('all');
                $("#showAll2").text(decodeHtml("<spring:message code="dashboard.tenVulnerabilities"/>"));
                count++;
            } else {
                $('#top10VulnTable').DataTable().clear();
                $('#top10VulnTable').DataTable().destroy();
                loadTableVulnerability('ten');
                $("#showAll2").text(decodeHtml("<spring:message code="dashboard.showAll"/>"));
                count++;
            }
        }
        function loadTableAsset(allOrTen, snapshot) {
            topScore = 0;
            var theTable;
            if(snapshot !== undefined) {
                theTable = $('#top10AssetTable').dataTable({
                    "aoColumnDefs": [{"bSortable": false, "aTargets": [0]}],
                    "order": [[0, "desc"]],
                    "searching": false,
                    "bLengthChange": false,
                    "pageLength": 10,
                    "scrollX": true,
                    "bInfo": false,
                    "columns": [
                        {"data": function (data, type, dataToSet) {
                                if (data.score > topScore) {
                                    topScore = data.score;
                                }
                                var interval = topScore / 5;
                                if (interval === 0) {
                                    interval = 1;
                                }
                                if (data.score === null) {
                                    return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                                } else {
                                    if (data.score >= interval * 4) {
                                        return '<div  style="border-top: 25px solid #F80812;" class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    } else if (data.score >= interval * 3) {
                                        return '<div  style="border-top: 25px solid #F88008;" class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    } else if (data.score >= interval * 2) {
                                        return '<div  style="border-top: 25px solid #F8C508; color: black;" class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    } else if (data.score >= interval * 1) {
                                        return '<div  style="border-top: 25px solid #FEFE60; color: black; " class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    } else {
                                        return '<div  style="border-top: 25px solid #F9FABB; color: black; " class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                if(data.assetType === 'VIRTUAL_HOST' && data.otherIps !== null && data.otherIps.length > 0) {
                                    return data.otherIps[0];
                                } else {
                                    if (data.hostname === "" || data.hostname === null) {
                                        var word = data.ip;
                                        if (word.length > 30) {
                                             return '<a style="color : black;text-decoration: none" data-toggle="tooltip" data-placement="right" title="' + data.ip + '" ' + 'onclick="showModal(\'' + data.assetId + '\',' + topScore + ')">' + data.ip +'</a>';
                                        } else {
                                            return '<div style ="height:25px;"><a style="color : black;text-decoration: none;" onclick="showModal(\'' + data.assetId + '\',' + topScore + ')">' + data.ip + '</a></div>';
                                        }
                                    } else {
                                        
                                            return '<a style="color : black;text-decoration: none" data-toggle="tooltip" data-placement="right" title="' + data.hostname +' (' + data.ip + ') ' + '" ' + 'onclick="showModal(\'' + data.assetId + '\',' + topScore + ')">' + data.hostname + ' (' + data.ip + ') ' + '</a>';
                                        
                                    }
                                   
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                Number.prototype.pad = function (size) {
                                    var s = String(this);
                                    while (s.length < (size || 2)) {
                                        s = "0" + s;
                                    }
                                    return s;
                                };
                                var vulnerabilityCountForSorting = (data.vulnerabilityCount).pad(4);
                                if (data.vulnerabilityCount === null) {
                                    return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                                } else {
                                    return '<div style ="height:25px;text-align:center;"><span style="display:none">' + vulnerabilityCountForSorting + '</span><b>' + data.criticalVulnerabilityCount + ' / ' + data.vulnerabilityCount + '</b></div>';
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                    ],
                    "data": snapshot.data,
                    "drawCallback": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $('[data-toggle="popover"]').popover({html: true,container: 'body'});
                    },
                    "language": {
                    "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                    "processing": "<spring:message code="generic.tableLoading"/>",
                    "search": "<spring:message code="generic.search"/>  ",
                    "paginate": {
                        "next": "<spring:message code="generic.next"/>",
                        "previous": "<spring:message code="generic.back"/>"
                    },
                    "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                    "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>'
                    }
                });
                assetData = snapshot.data;
                assetscore();
            } else {
                theTable = $('#top10AssetTable').dataTable({
                    "aoColumnDefs": [{"bSortable": false, "aTargets": [0]}],
                    "order": [[0, "desc"]],
                    "searching": false,
                    "bLengthChange": false,
                    "pageLength": 10,
                    "scrollX": true,
                    "bInfo": false,
                    "serverSide": true,
                    "columns": [
                        {"data": function (data, type, dataToSet) {
                                if (data.score > topScore) {
                                    topScore = data.score;
                                }
                                var interval = topScore / 5;
                                if (interval === 0) {
                                    interval = 1;
                                }
                                if (data.score === null) {
                                    return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                                } else {
                                    if (data.score >= interval * 4) {
                                        return '<div  style="border-top: 25px solid #F80812;" class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    } else if (data.score >= interval * 3) {
                                        return '<div  style="border-top: 25px solid #F88008;" class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    } else if (data.score >= interval * 2) {
                                        return '<div  style="border-top: 25px solid #F8C508; color: black;" class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    } else if (data.score >= interval * 1) {
                                        return '<div  style="border-top: 25px solid #FEFE60; color: black; " class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    } else {
                                        return '<div  style="border-top: 25px solid #F9FABB; color: black; " class="bizzy-riskScore"><p>' + data.score + '</p></div>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                if(data.assetType === 'VIRTUAL_HOST' && data.otherIps !== null && data.otherIps.length > 0) {
                                    return data.otherIps[0];
                                } else {
                                    if (data.hostname === "" || data.hostname === null) {
                                        var word = data.ip;
                                        if (word.length > 30) {
                                             return '<a style="color : black;text-decoration: none" data-toggle="tooltip" data-placement="right" title="' + data.ip + '" ' + 'onclick="showModal(\'' + data.assetId + '\',' + topScore + ')">' + data.ip +'</a>';
                                        } else {
                                            return '<div style ="height:25px;"><a style="color : black;text-decoration: none;" onclick="showModal(\'' + data.assetId + '\',' + topScore + ')">' + data.ip + '</a></div>';
                                        }
                                    } else {
                                       
                                            return '<a style="color : black;text-decoration: none" data-toggle="tooltip" data-placement="right" title="' + data.hostname +' (' + data.ip + ') ' + '" ' + 'onclick="showModal(\'' + data.assetId + '\',' + topScore + ')">' + data.hostname + ' (' + data.ip + ') ' + '</a>';
                                       
                                    }
                                   
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                       
                        {"data": function (data, type, dataToSet) {
                                Number.prototype.pad = function (size) {
                                    var s = String(this);
                                    while (s.length < (size || 2)) {
                                        s = "0" + s;
                                    }
                                    return s;
                                };
                                var vulnerabilityCountForSorting = (data.vulnerabilityCount).pad(4);
                                if (data.vulnerabilityCount === null) {
                                    return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                                } else {
                                    return '<div style ="height:25px;text-align:center;"><span style="display:none">' + vulnerabilityCountForSorting + '</span><b>' + data.criticalVulnerabilityCount + ' / ' + data.vulnerabilityCount + '</b></div>';
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadTopTenAssets.json",
                        "data": function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                                obj[key] = tempObj[key];
                            });
                            obj["allOrTen"] = allOrTen;
                        },
                        // error callback to handle error
                        "error": function (jqXHR, textStatus, errorThrown) {
                            if(jqXHR.status === 403) {
                                window.location = '../error/userForbidden.htm';
                            } else {
                                console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                                //  alert(decodeHtml("<spring:message code="listCategories.tableError"/>"));
                            }
                        },
                        "complete": function (data) {
                            assetData = data.responseJSON.data;
                            assetscore();
                        }
                    },
                    "initComplete": function (settings, json) {
                        if (json.data.length !== 0) {
                            topScore = json.data[0].score;
                            if (riskScoreCursorChart !== undefined)
                                riskScoreCursorChart.dispose();
                            riskScoreCursorChart = am4core.create("riskScoreCursor", am4charts.GaugeChart);
                            riskScoreCursorChart.innerRadius = am4core.percent(62);

                            /**
                             * Axis for ranges
                             */

                            colorSet = new am4core.ColorSet();

                            riskScoreCursorAxis2 = riskScoreCursorChart.xAxes.push(new am4charts.ValueAxis());
                            riskScoreCursorAxis2.min = 0;
                            riskScoreCursorAxis2.max = topScore;
                            riskScoreCursorAxis2.renderer.innerRadius = 10;
                            riskScoreCursorAxis2.strictMinMax = true;
                            riskScoreCursorAxis2.renderer.labels.template.disabled = true;
                            riskScoreCursorAxis2.renderer.ticks.template.disabled = true;
                            riskScoreCursorAxis2.renderer.grid.template.disabled = true;

                            riskScoreCursorRange0 = riskScoreCursorAxis2.axisRanges.create();
                            riskScoreCursorRange0.value = 0;
                            riskScoreCursorRange0.endValue = 50;
                            riskScoreCursorRange0.axisFill.fillOpacity = 1;
                            riskScoreCursorRange0.axisFill.fill = colorSet.getIndex(0);

                            var riskScoreCursorFm = new am4core.LinearGradientModifier();
                            riskScoreCursorFm.brightnesses = [-0.8, 1, -0.8];
                            riskScoreCursorFm.offsets = [0, 0.5, 1];
                            riskScoreCursorRange0.axisFill.fillModifier = riskScoreCursorFm;

                            riskScoreCursorRange1 = riskScoreCursorAxis2.axisRanges.create();
                            riskScoreCursorRange1.value = 50;
                            riskScoreCursorRange1.endValue = 100;
                            riskScoreCursorRange1.axisFill.fillOpacity = 1;
                            riskScoreCursorRange1.axisFill.fill = colorSet.getIndex(2);
                            var riskScoreCursorFm2 = new am4core.LinearGradientModifier();
                            riskScoreCursorFm2.brightnesses = [-0.2, 0.2, -0.2];
                            riskScoreCursorFm2.offsets = [0, 0.5, 1];
                            riskScoreCursorRange1.axisFill.fillModifier = riskScoreCursorFm2;

                            riskScoreCursorLabel = riskScoreCursorChart.radarContainer.createChild(am4core.Label);
                            riskScoreCursorLabel.isMeasured = false;
                            riskScoreCursorLabel.fontSize = 25;
                            riskScoreCursorLabel.x = am4core.percent(50);
                            riskScoreCursorLabel.y = am4core.percent(100);
                            riskScoreCursorLabel.horizontalCenter = "middle";
                            riskScoreCursorLabel.verticalCenter = "bottom";
                            riskScoreCursorLabel.text = "50%";

                            riskScoreCursorHand = riskScoreCursorChart.hands.push(new am4charts.ClockHand());
                            riskScoreCursorHand.axis = riskScoreCursorAxis2;
                            riskScoreCursorHand.innerRadius = am4core.percent(30);
                            riskScoreCursorHand.startWidth = 10;
                            riskScoreCursorHand.pin.disabled = true;
                            riskScoreCursorHand.value = 50;
                        }
                        $('[data-toggle="tooltip"]').tooltip();
                        $('[data-toggle="popover"]').popover({html: true,container: 'body'});
                    },
                    "drawCallback": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $('[data-toggle="popover"]').popover({html: true,container: 'body'});
                    },
                    "language": {
                    "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                    "processing": "<spring:message code="generic.tableLoading"/>",
                    "search": "<spring:message code="generic.search"/>  ",
                    "paginate": {
                        "next": "<spring:message code="generic.next"/>",
                        "previous": "<spring:message code="generic.back"/>"
                    },
                    "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                    "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>'
                    }
                });
            }
        }
        function loadTableVulnerability(allOrTen, snapshot) {
            var theTable2;
            if(snapshot !== undefined) {
                theTable2 = $('#top10VulnTable').dataTable({
                    "order": [[0, "desc"]],
                    "searching": false,
                    "bLengthChange": false,
                    "pageLength": 10,
                    "scrollX": true,
                    "bInfo": false,
                    "columns": [

                        {"data": function (data, type, dataToSet) {

                                if (data.riskScore === null) {
                                    return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                                } else {
                                    data.riskScore = Math.round(data.riskScore * 10) / 10;
                                    if (data.riskScore >= 80) {
                                        return '<div  style="border-top: 25px solid #F80812;" class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                    } else if (data.riskScore >= 60) {
                                        return '<div  style="border-top: 25px solid #F88008;" class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                    } else if (data.riskScore >= 40) {
                                        return '<div  style="border-top: 25px solid #F8C508; color: black;" class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                    } else if (data.riskScore >= 20) {
                                        return '<div  style="border-top: 25px solid #FEFE60; color: black; " class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                    } else {
                                        return '<div  style="border-top: 25px solid #F9FABB; color: black; " class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.vulnerability.name === null || data.vulnerability.name === "") {
                                    return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                                } else {
                                    var temp = data.vulnerability.name;
                                    if (temp.length <= 40) {
                                        return '<a style="color : black;text-decoration: none;cursor: unset;">' + temp + '</a>';
                                    } else {
                                        return '<a id="columnTool" style="color : black;text-decoration: none;cursor: unset;" data-toggle="tooltip" data-placement="top" title="' + temp + '">' + temp + '</a>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                if (data.vulnerability.asset.assetId === null || data.vulnerability.asset.assetId === "") {
                                    return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                                } else {
                                    if (data.hostname === "" || data.hostname === null) {
                                        var svId = data.scanVulnerabilityId;
                                    var assId = data.vulnerability.asset.assetId;
                                    var check = svId.indexOf(',');
                                    if (check === -1) { //bir varlık
                                        if (data.vulnerability.asset.ip.length <= 15) {
                                            return '<a href="${pageContext.request.contextPath}/customer/viewVulnerability.htm?scanVulnerabilityId=' + svId + '" target="_blank" style="color : black;" >' + data.vulnerability.asset.ip + '</a>';
                                        } else {
                                            var shortString = decodeHtml(data.vulnerability.asset.ip).substring(0, 14);
                                            return '<a href="${pageContext.request.contextPath}/customer/viewVulnerability.htm?scanVulnerabilityId=' + svId + '" target="_blank" style="color : black;" data-toggle="tooltip" data-placement="right" title="' + data.vulnerability.asset.ip + '" >' + shortString + '...' + '</a>';
                                        }
                                    } else {          //birden fazla varlık
                                        var shortString = decodeHtml(data.vulnerability.asset.ip).substring(0, 14);
                                        var ips = data.vulnerability.asset.ip;
                                        var svIds = data.scanVulnerabilityId;
                                        var ids = data.vulnerability.asset.assetId;
                                        var assets = ips.split(', ');
                                        var svIds = svIds.split(', ');
                                        var ids = ids.split(', ');
                                        var links = "";
                                        for (var a = 0; a < assets.length; a++) {
                                            links += "<a href='${pageContext.request.contextPath}/customer/viewVulnerability.htm?scanVulnerabilityId=" + svIds[a] + "' target='_blank' style='color : black'>" + assets[a] + "</a>, ";
                                        }
                                        links = links.substring(0, links.length - 2);
                                        return '<a tabindex="0" data-trigger="focus" data-toggle="popover" data-container="body" data-placement="top" title="<spring:message code="generic.assets"/>" \n\
        data-content="' + links + '" \n\
        style="color : black;">' + shortString + '...' + '</a>';
                                    }
                                    } else {
                                    
                                            var ips = data.vulnerability.asset.ip;
                                            var svIds = data.scanVulnerabilityId;
                                            var ids = data.vulnerability.asset.assetId;
                                            var assets = ips.split(', ');
                                            var svIds = svIds.split(', ');
                                            var ids = ids.split(', ');
                                            var links = "";
                                            for (var a = 0; a < assets.length; a++) {
                                                var host=data.hostname +" (" + assets[a] + ") ";
                                                var shortString = decodeHtml(host).substring(0, 14);
                                                links += "<a data-toggle='tooltip' data-placement='right' title='" + data.hostname +" (" + assets[a] + ") " + "'  href='${pageContext.request.contextPath}/customer/viewVulnerability.htm?scanVulnerabilityId=" + svIds[a] + "' target='_blank' style='color : black'>" + shortString + '...' + "</a> ";
                                            }
                                            links = links.substring(0, links.length - 2);
                                            return links;
                                    }
                                    
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {
                                Number.prototype.pad = function (size) {
                                    var s = String(this);
                                    while (s.length < (size || 2)) {
                                        s = "0" + s;
                                    }
                                    return s;
                                };
                                var oac = data.openAssetCount;
                                var cac = data.closedAssetCount;
                                var openAssetCountForSorting = (oac).pad(4);
                                return '<div style ="height:25px;text-align:center;"><span style="display:none">' + openAssetCountForSorting + '</span><b>' + oac + ' / ' + (parseInt(cac)+parseInt(oac)) + '</b></div>';
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {"data": function (data, type, dataToSet) {

                                if (data.vulnerability.riskLevel === null) {
                                    return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                                } else {
                                    switch (data.vulnerability.riskLevel) {
                                        case 1 :
                                            return '<img data-toggle="tooltip" data-placement="top" title="1" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk2.svg" width="25"/>';
                                            break;
                                        case 2 :
                                            return '<img data-toggle="tooltip" data-placement="top" title="2" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk4.svg" width="25"/>';
                                            break;
                                        case 3 :
                                            return '<img data-toggle="tooltip" data-placement="top" title="3" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk6.svg" width="25"/>';
                                            break;
                                        case 4 :
                                            return '<img data-toggle="tooltip" data-placement="top" title="4" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk8.svg" width="25"/>';
                                            break;
                                        case 5 :
                                            return '<img data-toggle="tooltip" data-placement="top" title="5" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk10.svg" width="25"/>';
                                            break;
                                        default :
                                            return '<div style ="height:25px;"></div>';
                                    }
                                }
                            },
                            "searchable": false,
                            "orderable": false
                        }
                    ],
                    "columnDefs": [
                        {"type": "data.vulnerability.riskLevel", targets: 4}
                    ],
                    "data": snapshot.data,
                    "initComplete": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $('[data-toggle="popover"]').popover({html: true});
                    },
                    "drawCallback": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                        $('[data-toggle="popover"]').popover({html: true});
                    },
                    "language": {
                    "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                    "processing": "<spring:message code="generic.tableLoading"/>",
                    "search": "<spring:message code="generic.search"/>  ",
                    "paginate": {
                        "next": "<spring:message code="generic.next"/>",
                        "previous": "<spring:message code="generic.back"/>"
                    },
                    "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                    "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>'
                    }
                });
            } else {
                theTable2 = $('#top10VulnTable').dataTable({
                   "order": [[0, "desc"]],
                   "searching": false,
                   "bLengthChange": false,
                   "pageLength": 10,
                   "scrollX": true,
                   "bInfo": false,
                   "serverSide": true,
                   "columns": [

                       {"data": function (data, type, dataToSet) {

                               if (data.riskScore === null) {
                                   return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                               } else {
                                   data.riskScore = Math.round(data.riskScore * 10) / 10;
                                   if (data.riskScore >= 80) {
                                       return '<div  style="border-top: 25px solid #F80812;" class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                   } else if (data.riskScore >= 60) {
                                       return '<div  style="border-top: 25px solid #F88008;" class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                   } else if (data.riskScore >= 40) {
                                       return '<div  style="border-top: 25px solid #F8C508; color: black;" class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                   } else if (data.riskScore >= 20) {
                                       return '<div  style="border-top: 25px solid #FEFE60; color: black; " class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                   } else {
                                       return '<div  style="border-top: 25px solid #F9FABB; color: black; " class="bizzy-riskScore"><p>' + data.riskScore + '</p></div>';
                                   }
                               }
                           },
                           "searchable": false,
                           "orderable": false
                       },
                       {"data": function (data, type, dataToSet) {
                               if (data.vulnerability.name === null || data.vulnerability.name === "") {
                                   return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                               } else {
                                   var temp = data.vulnerability.name;
                                   if (temp.length <= 40) {
                                       return '<a style="color : black;text-decoration: none;cursor: unset;">' + temp + '</a>';
                                   } else {
                                       return '<a id="columnTool" style="color : black;text-decoration: none;cursor: unset;" data-toggle="tooltip" data-placement="top" title="' + temp + '">' + temp + '</a>';
                                   }
                               }
                           },
                           "searchable": false,
                           "orderable": false
                       },
                       {"data": function (data, type, dataToSet) {
                               if (data.vulnerability.asset.assetId === null || data.vulnerability.asset.assetId === "") {
                                   return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                               } else {
                                   if (data.vulnerability.asset.hostname === "" || data.vulnerability.asset.hostname === null) {
                                        var svId = data.scanVulnerabilityId;
                                        var assId = data.vulnerability.asset.assetId;
                                        var check = svId.indexOf(',');
                                        if (check === -1) { //bir varlık
                                            if (data.vulnerability.asset.ip.length <= 15) {
                                                return '<a href="${pageContext.request.contextPath}/customer/viewVulnerability.htm?scanVulnerabilityId=' + svId + '" target="_blank" style="color : black;" >' + data.vulnerability.asset.ip + '</a>';
                                            } else {
                                                var shortString = decodeHtml(data.vulnerability.asset.ip).substring(0, 14);
                                                return '<a href="${pageContext.request.contextPath}/customer/viewVulnerability.htm?scanVulnerabilityId=' + svId + '" target="_blank" style="color : black;" data-toggle="tooltip" data-placement="right" title="' + data.vulnerability.asset.ip + '" >' + shortString + '...' + '</a>';
                                            }
                                        } else {          //birden fazla varlık
                                            var shortString = decodeHtml(data.vulnerability.asset.ip).substring(0, 14);
                                            var ips = data.vulnerability.asset.ip;
                                            var svIds = data.scanVulnerabilityId;
                                            var ids = data.vulnerability.asset.assetId;
                                            var assets = ips.split(', ');
                                            var svIds = svIds.split(', ');
                                            var ids = ids.split(', ');
                                            var links = "";
                                            for (var a = 0; a < assets.length; a++) {
                                                links += "<a href='${pageContext.request.contextPath}/customer/viewVulnerability.htm?scanVulnerabilityId=" + svIds[a] + "' target='_blank' style='color : black'>" + assets[a] + "</a>, ";
                                            }
                                            links = links.substring(0, links.length - 2);
                                            return '<a tabindex="0" data-trigger="focus" data-toggle="popover" data-container="body" data-placement="top" title="<spring:message code="generic.assets"/>" \n\
            data-content="' + links + '" \n\
            style="color : black;">' + shortString + '...' + '</a>';
                                        }
                                    } else {
                                     
                                        
                                            var ips = data.vulnerability.asset.ip;
                                            var svIds = data.scanVulnerabilityId;
                                            var ids = data.vulnerability.asset.assetId;
                                            var assets = ips.split(', ');
                                            var svIds = svIds.split(', ');
                                            var ids = ids.split(', ');
                                            var links = "";
                                            for (var a = 0; a < assets.length; a++) {
                                                var host= data.vulnerability.asset.hostname + " (" + assets[a] + ") ";
                                                var shortString = decodeHtml(host).substring(0, 14);
                                                links += "<a data-toggle='tooltip' data-placement='right' title='" + data.vulnerability.asset.hostname +" (" + assets[a] + ") " + "'  href='${pageContext.request.contextPath}/customer/viewVulnerability.htm?scanVulnerabilityId=" + svIds[a] + "' target='_blank' style='color : black'>" + shortString + '...' + "</a> ";
                                            }
                                            links = links.substring(0, links.length - 2);
                                            return links;
                                        
                                    }
                                   
                               }
                           },
                           "searchable": false,
                           "orderable": false
                       },
                       {"data": function (data, type, dataToSet) {
                               Number.prototype.pad = function (size) {
                                   var s = String(this);
                                   while (s.length < (size || 2)) {
                                       s = "0" + s;
                                   }
                                   return s;
                               };
                               var oac = data.openAssetCount;
                               var cac = data.closedAssetCount;
                               var openAssetCountForSorting = (oac).pad(4);
                               return '<div style ="height:25px;text-align:center;"><span style="display:none">' + openAssetCountForSorting + '</span><b>' + oac + ' / ' + (parseInt(cac)+parseInt(oac)) + '</b></div>';
                           },
                           "searchable": false,
                           "orderable": false
                       },
                       {"data": function (data, type, dataToSet) {

                               if (data.vulnerability.riskLevel === null) {
                                   return '<div style ="height:25px;"><i class="fas fa-minus"></i></div>';
                               } else {
                                   switch (data.vulnerability.riskLevel) {
                                       case 1 :
                                           return '<img data-toggle="tooltip" data-placement="top" title="1" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk2.svg" width="25"/>';
                                           break;
                                       case 2 :
                                           return '<img data-toggle="tooltip" data-placement="top" title="2" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk4.svg" width="25"/>';
                                           break;
                                       case 3 :
                                           return '<img data-toggle="tooltip" data-placement="top" title="3" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk6.svg" width="25"/>';
                                           break;
                                       case 4 :
                                           return '<img data-toggle="tooltip" data-placement="top" title="4" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk8.svg" width="25"/>';
                                           break;
                                       case 5 :
                                           return '<img data-toggle="tooltip" data-placement="top" title="5" style ="display:block; margin:0 auto;" src="${pageContext.request.contextPath}/resources/svg/risk10.svg" width="25"/>';
                                           break;
                                       default :
                                           return '<div style ="height:25px;"></div>';
                                   }
                               }
                           },
                           "searchable": false,
                           "orderable": false
                       }
                   ],
                   "columnDefs": [
                       {"type": "data.vulnerability.riskLevel", targets: 4}
                   ],
                   "ajax": {
                       "type": "POST",
                       "url": "loadTopTenVulnerabilities.json",
                       "data": function (obj) {
                           var tempObj = getObjectByForm("searchForm");
                           Object.keys(tempObj).forEach(function (key) {
                               obj[key] = tempObj[key];
                           });
                           obj["page"] = 'index';
                           obj["allOrTen"] = allOrTen;
                       },
                       // error callback to handle error
                       "error": function (jqXHR, textStatus, errorThrown) {
                           if(jqXHR.status === 403) {
                               window.location = '../error/userForbidden.htm';
                           } else {
                               console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                               //  alert(decodeHtml("<spring:message code="listCategories.tableError"/>"));
                           }
                       }
                   },
                   "initComplete": function (settings, json) {
                       $('[data-toggle="tooltip"]').tooltip();
                       $('[data-toggle="popover"]').popover({html: true});

                       $("input:radio[name=options]").change(function () {
                           filterGraphsByInterval();
                       });
                   },
                   "drawCallback": function (settings, json) {
                       $('[data-toggle="tooltip"]').tooltip();
                       $('[data-toggle="popover"]').popover({html: true});
                   },
                   "language": {
                    "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                    "processing": "<spring:message code="generic.tableLoading"/>",
                    "search": "<spring:message code="generic.search"/>  ",
                    "paginate": {
                        "next": "<spring:message code="generic.next"/>",
                        "previous": "<spring:message code="generic.back"/>"
                    },
                    "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                    "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>'
                    }
               });
            }
        }
        //Toplam Zafiyet kutucuğundan zafiyetlere yönlendirildiğinde
        function totalVulnerabilitiesClicked() {
            localStorage.setItem("clicked", "true");
        }

        function box5Redirect() {
            var url = '../customer/listVulnerabilities.htm?level=5';
            ;
            url = addFilterToUrl(url);
            window.open(url, '_blank');
        }
        function box4Redirect() {
            var url = '../customer/listVulnerabilities.htm?level=4';
            ;
            url = addFilterToUrl(url);
            window.open(url, '_blank');
        }
        function box3Redirect() {
            var url = '../customer/listVulnerabilities.htm?level=3';
            ;
            url = addFilterToUrl(url);
            window.open(url, '_blank');
        }
        function box2Redirect() {
            var url = '../customer/listVulnerabilities.htm?level=2';
            ;
            url = addFilterToUrl(url);
            window.open(url, '_blank');
        }
        function box1Redirect() {
            var url = '../customer/listVulnerabilities.htm?level=1';
            ;
            url = addFilterToUrl(url);
            window.open(url, '_blank');
        }
        function boxOldestOpenUrgentVuln() {
            var url = '../customer/listVulnerabilities.htm?level=5&statusValues=OPEN,RISK_ACCEPTED,RECHECK,ON_HOLD,IN_PROGRESS';
            url = addFilterToUrl(url);
            window.open(url, '_blank');
        }
        function boxOpenVulns() {
            var url = '../customer/listVulnerabilities.htm?statusValues=OPEN,RISK_ACCEPTED,RECHECK,ON_HOLD,IN_PROGRESS';
            url = addFilterToUrl(url);
            window.open(url, '_blank');
        }

        $(document).ready(function () {
            document.title = '<spring:message code="main.theme.dashboard"/> - BIZZY';
            $('[data-toggle="popover"]').popover({html: true,container: 'body'});
            $("input:radio[name=osoptions]").change(function () {
                operatingsystemsfunction();
            });
            
            $("#groups").select2({
                        tags: false,
                        multiple: true,
                        ajax: {
                        url: "getAssetGroupList.json",
                            dataType: 'json',
                            type: "post",
                            delay: 0,
                            data: function (params) {
                            var obj = {
                            assetGroupName: params.term,
                                    '${_csrf.parameterName}': "${_csrf.token}"
                            };
                            return obj;
                            },
                            processResults: function (data) {
                            var newResults = [];
                            $.each(data, function(index, item)
                            {
                         
                            newResults.push({
                            id: decodeHtml(item.groupId),
                                    text: decodeHtml(item.name)
                            });
                            });
                            return {
                            results: newResults
                            };
                            },
                            cache: true
                    },
                    minimumInputLength: 3,
                    language: { inputTooShort: function () { return '<spring:message code="generic.selectMinChar"/>'; },
                            searching: function () { return '<spring:message code="generic.selectSearching"/>'; },
                            noResults: function () { return '<spring:message code="generic.selectNoResult"/>'; }
                    }
            });
            
            
            
             $("#scans").select2({
            tags: false,
                    multiple: true,
                    ajax: {
                    url: "getScansByName.json",
                            dataType: 'json',
                            type: "post",
                            delay: 0,
                            data: function (params) {
                            var obj = {
                            scanName: params.term,
                                    '${_csrf.parameterName}': "${_csrf.token}"
                            };
                            return obj;
                            },
                            processResults: function (data) {
                            var newResults = [];
                            $.each(data, function(index, item)
                            {
                            newResults.push({
                            id: decodeHtml(item.scanId),
                                    text: decodeHtml(item.name)
                            });
                            });
                            return {
                            results: newResults
                            };
                            },
                            cache: true
                    },
                    minimumInputLength: 3,
                    language: { inputTooShort: function () { return '<spring:message code="generic.selectMinChar"/>'; },
                            searching: function () { return '<spring:message code="generic.selectSearching"/>'; },
                            noResults: function () { return '<spring:message code="generic.selectNoResult"/>'; }
                    }
            });
            
            var tabs = $('.bizzy-upanel-tabs');
            var items = $('.bizzy-upanel-tabs').find('a').length;
            var selector = $(".bizzy-upanel-tabs").find(".bizzy-upanel-selector");
            var activeItem = tabs.find('.active');
            var activeWidth = activeItem.innerWidth();
            $(".bizzy-upanel-selector").css({
                "left": activeItem.position.left + "px",
                "width": activeWidth + "px"
            });

            $(".bizzy-upanel-tabs").on("click", "a", function (e) {
                e.preventDefault();
                $('.bizzy-upanel-tabs a').removeClass("active");
                $(this).addClass('active');
                var activeWidth = $(this).innerWidth();
                var itemPos = $(this).position();
                $(".bizzy-upanel-selector").css({
                    "left": itemPos.left + "px",
                    "width": activeWidth + "px"
                });
            });
            function loadUserInfos() {
                $('#userTable').dataTable({
                    "lengthMenu": [[5, 10], [5, 10]],
                    "order": [[2, "desc"]],
                    "searching": false,
                    "scrollY": "160px",
                    "scrollX": true,
                    "bLengthChange": false,
                    "serverSide": true,
                    "bInfo": false,
                    "paging": true,
                    "autoWidth": false,
                    <c:choose>
                        <c:when test="${sessionScope.performanceScoreActive}">  
                    "columnDefs": [
                        {"width": "30px", "targets": 1},
                        {"width": "80px", "targets": 2}
                    ],                            
                        </c:when>
                        <c:otherwise>                            
                    "columnDefs": [
                        {"width": "100px", "targets": 1},
                        {"width": "20px", "targets": 2}
                    ],
                        </c:otherwise>  
                    </c:choose>                              
                    "columns": [
                        {
                            "data": function (data, type, dataToSet) {
                                var html = '<a href="../ticket/view/viewTicket.htm?ticketId=' + data.ticketId + '">' + data.name + '</a>';
                                return html;
                            },
                            "searchable": false,
                            "orderable": false
                        },
                        {
                            "data": "ticketStatus.languageText",
                            "orderable": false
                        },
                    <c:choose>
                        <c:when test="${sessionScope.performanceScoreActive}">  
                        {"data": function (data, type) {
                                return getVprScore(data);
                            },
                            "orderable": true,
                            "searchable": false,
                            "orderData": [4]
                        },
                        </c:when>
                        <c:otherwise>
                        {
                            "data": "ticketPriority.languageText",
                            "orderable": true
                        },                            
                        </c:otherwise>  
                    </c:choose>            
                        {
                            "data": "assigneeDatatableText",
                            "orderable": false
                        }
                        ,{
                            "data": function (data, type, dataToSet) {
                                return slaTimelineProjection(data);
                            },
                            "searchable": false,
                            "orderable": false
                        }      
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadAllTickets.data",
                        "data": function (obj) {
                            var tempObj = getObjectByForm("searchForm");
                            Object.keys(tempObj).forEach(function (key) {
                                obj[key] = tempObj[key];
                            });
                        },
                        "error": function (jqXHR, textStatus, errorThrown) {
                            console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                        }
                    },
                    "language": {
                    "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                    "processing": "<spring:message code="generic.tableLoading"/>",
                    "search": "<spring:message code="generic.search"/>  ",
                    "paginate": {
                        "next": "<spring:message code="generic.next"/>",
                        "previous": "<spring:message code="generic.back"/>"
                    },
                    "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                    "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>'
                    },
                    "drawCallback": function (settings, json) {
                    },
                    "dom": '<"top"i>rt<"bottom"flp><"clear">'
                });
            }
            count = 0;
            countAss = 0;

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

            //SAYFA AÇILDIĞINDA DEFAULT AÇILACAK GRAFİKLER
            openAssetsTab();       

        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER, ROLE_COMPANY_MANAGER_READONLY')">
            <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER')">
            var timeStamps = [];
            var sliderValues = [];
            <c:forEach var="item" items="${timeStamps}">
            timeStamps.push(decodeHtml('<c:out value="${item}"/>'));
            </c:forEach>
            timeStamps.forEach(function(element){
                sliderValues.push(timeStamps.indexOf(element));
            });
            $("#timeSlider").ionRangeSlider({
                values: sliderValues,
                from: sliderValues[sliderValues.length - 1],
                prettify: function (n) {
                    var ind = sliderValues.indexOf(n);
                    return timeStamps[ind];
                },
                grid_margin: false,
                grid: true,
                //hide_min_max: true,
                onChange: function (data) {
                    sliderChanged(data.from_pretty);
                }

            });
            </sec:authorize>
            smallRiskScoreFunction();
            riskTable();
            vulnByStatusFunction();
            riskEffectHeatmapGraphFunction();
            topTenWebAppVulnFunction();
            topTables();   
        </sec:authorize>
        <sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY')">
            loadUserInfos();
            userPerformanceChartFunction();
            </sec:authorize>
        </sec:authorize>
            topScore = 0;
        });
    </script>

    <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
</sec:authorize>
<sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
    <script type="text/javascript">

        function addFilterToUrl(url) {
            var obj = getObjectByForm("searchForm");
            if (obj.statuses !== undefined) {
                url += '&filterStatuses=' + obj.statuses;
            }
            if (obj.sources !== undefined) {
                url += '&filterSources=' + obj.sources;
            }
            if (obj.riskLevels !== undefined) {
                url += '&filterRiskLevels=' + obj.riskLevels;
            }
            if (obj.groups !== undefined) {
                url += '&filterAssetGroups=' + obj.groups;
            }
            if (obj.scans !== undefined) {
                url += '&filterScans=' + obj.scans;
            }
            return url;
        }

        $('[data-toggle="tooltip"]').tooltip();

        var sourceDataHeat; //HEATMAP GRAFİĞİ DEĞİŞKENLERİ
        var graphsHeat;
        var firstmonthHeat;
        var secondmonthHeat;
        var thirdmonthHeat;
        var monthsHeat;

        function openAssetsTab() {
            $('#radarChart').on('load', assetscore());
            $('#top10ipgraph').on('load', top10ip());
            $('#assetrisk').on('load', assetvuln());
            $('#assetgroupsvuln').on('load', assetgroupsfunction());
            $('#vulnDayGraphTotal').on('load', vulnDayTotalFunction());
        }
        function openRiskMeterTab() {
            $('#vulnDayGraph').on('load', vulnDayFunction());           
            $('#vulnDayGraphStatus').on('load', vulnDayStatusFunction());
            $('#heatMap').on('load', heatMapFunction());
        }
        function openRiskScoreTab() {
            $('#riskScoreGraphByLevel').on('load', dailyRiskScoreCharts());
        }
        function openVulnerabilitiesTab() {
            $('#riskLevelVulnGraph').on('load', levelcount());
            $('#effectgraph').on('load', vulneffect());
            $('#top10kbgraph').on('load', top10kb());
            $('#rootcausegraph').on('load', rootcause());
            $('#cvegraph').on('load', cveDistribution());
        }
        function openPortsTab() {
            $('#portgraph').on('load', ports());
            $('#portservices').on('load', servicefunction());
            $('#operatingsystems').on('load', operatingsystemsfunction());
            $('#assetsbyassetgroup').on('load', assetsbyassetgroupfunction());
        }
        function openCategoriesTab() {
            $('#categorygraph').on('load', categoryfunction());
            $('#problemvulnerabilities').on('load', problemfunction());
            $('#serverDatatables').on('load', categoryTable());
        }
        function openPerformanceTab() {
            $('#levelOpenClosedCountGraph').on('load', levelOpenClosedCountFunction());
            $('#timegraph').on('load', timefunction());
            $('#totaltimegraph').on('load', totaltimefunction());
            $('#totalManualAddedVulGraph').on('load', totalManualAddedVulFunction());
            $('#numberOfOpenVulnerabilitiesOnUserGraph').on('load', numberOfOpenVulnerabilitiesOnUserFunction());
        }

        function filterGraphsByInterval() {
            vulnDayFunction();
            vulnDayTotalFunction();
            vulnDayStatusFunction();
        }

        function showBadgesValues(data) {
            var newAsset = data[0];
            var reCheckVuln = data[1];
            var newVuln = data[2];
            var newTicket = data[3];
            var openTicket = data[4];
            var closedTicket = data[5];
            var averageDay = data[6];
            var openDays = data[7];
            if (newAsset > 0) {
                $('#newAssetBadge').show();
                $('#newAssetBadge').html('<b>' + newAsset + '</b>');
            } else {
                $('#newAssetBadge').hide();
            }
            if (reCheckVuln > 0) {
                $('#reCheckVulnerabilityBadge').show();
                $('#reCheckVulnerabilityBadge').html('<b>' + reCheckVuln + '</b>');
            } else {
                $('#reCheckVulnerabilityBadge').hide();
            }
            if (newVuln > 0) {
                $('#newVulnerabilityBadge').show();
                $('#newVulnerabilityBadge').html('<b>' + newVuln + '</b>');
            } else {
                $('#newVulnerabilityBadge').hide();
            }
            if (newTicket > 0) {
                $('#newTicketBadge').show();
                $('#newTicketBadge').html('<b>' + newTicket + '</b>');
            } else {
                $('#newTicketBadge').hide();
            }
            $('#openTicketBadge').html('<b>' + openTicket + '</b>');
            $('#closedTicketBadge').html('<b>' + closedTicket + '</b>');
            $('#averageTicketBadge').html('<b>' + averageDay + ' <spring:message code="dashboard.day"/></b>');
            $('#oldestTicketBadge').html('<b>' + openDays + ' <spring:message code="dashboard.day"/></b>');

        }

        function userPerformanceChartFunction() {
            var obj = getObjectByForm("searchForm");
            if (userPerformanceChart !== undefined)
                userPerformanceChart.dispose();
            userPerformanceChart = am4core.create("userPerformanceChart", am4charts.XYChart);
        <c:choose>
            <c:when test="${selectedLanguage == 'en'}">
            </c:when>
            <c:when test="${selectedLanguage == 'tr'}">
            userPerformanceChart.language.locale = am4lang_tr_TR;
            </c:when>
        </c:choose>
            var categoryAxis = userPerformanceChart.xAxes.push(new am4charts.DateAxis());
            categoryAxis.dataFields.category = "date";
            categoryAxis.renderer.grid.template.location = 0;
            var valueAxis1 = userPerformanceChart.yAxes.push(new am4charts.ValueAxis());
            valueAxis1.title.text = "<spring:message code="score.title"/>";
        <c:if test="${!sessionScope.performanceScoreActive}">          
            var valueAxis2 = userPerformanceChart.yAxes.push(new am4charts.ValueAxis());
            valueAxis2.title.text = "<spring:message code="dashboard.closedTicketNumbers"/>";
            valueAxis2.renderer.opposite = true;
            valueAxis2.renderer.grid.template.disabled = true;
        </c:if>    
            function createUserPerformanceChartSeries(field, name) {
                var series = userPerformanceChart.series.push(new am4charts.ColumnSeries());
                series.name = name;
                series.dataFields.valueY = field;
                series.dataFields.dateX = "date";
                series.yAxis = valueAxis2;
                series.sequencedInterpolation = true;
                series.stacked = true;
                series.columns.template.width = am4core.percent(60);
                series.columns.template.tooltipText = "[bold]{name}[/]\n[font-size:14px]{categoryX}: {valueY}";
                var labelBullet = series.bullets.push(new am4charts.LabelBullet());
                labelBullet.label.text = "{valueY}";
                labelBullet.locationY = 0.5;
                labelBullet.label.adapter.add("text", function (text, target) {
                    if (target.dataItem && target.dataItem.valueY === 0) {
                        return "";
                    }
                    return text;
                });
                return series;
            }
        <c:if test="${!sessionScope.performanceScoreActive}">
            createUserPerformanceChartSeries("early", "<spring:message code="viewScoreboard.onTimeNumber"/>");
            createUserPerformanceChartSeries("late", "<spring:message code="viewScoreboard.lateNumber"/>");
        </c:if>
            var lineSeries = userPerformanceChart.series.push(new am4charts.LineSeries());
            lineSeries.name = "<spring:message code="score.title"/>";
            lineSeries.dataFields.valueY = "score";
            lineSeries.dataFields.dateX = "date";
            lineSeries.yAxis = valueAxis1;
            lineSeries.stroke = am4core.color("#fdd400");
            lineSeries.strokeWidth = 3;
            lineSeries.propertyFields.strokeDasharray = "lineDash";
            lineSeries.tooltip.label.textAlign = "middle";
            userPerformanceChart.dateFormatter.inputDateFormat = "dd.MM.yyyy HH:mm:ss";

            var bullet = lineSeries.bullets.push(new am4charts.Bullet());
            bullet.fill = am4core.color("#fdd400"); // tooltips grab fill from parent by default
            bullet.tooltipText = "[#fff font-size: 15px]{name}\n[/][#fff font-size: 20px]{valueY}[/] [#fff]{additional}[/]"
            var circle = bullet.createChild(am4core.Circle);
            circle.radius = 4;
            circle.fill = am4core.color("#fff");
            circle.strokeWidth = 3;
            // Add scrollbar
            userPerformanceChart.scrollbarX = new am4core.Scrollbar();
            userPerformanceChart.scrollbarX.parent = userPerformanceChart.bottomAxesContainer;
            
            
            userPerformanceChartIndicator = userPerformanceChart.tooltipContainer.createChild(am4core.Container);
            userPerformanceChartIndicator.background.fill = am4core.color("#fff");
            userPerformanceChartIndicator.background.fillOpacity = 0.8;
            userPerformanceChartIndicator.width = am4core.percent(100);
            userPerformanceChartIndicator.height = am4core.percent(100);

            var userPerformanceChartIndicatorLabel = userPerformanceChartIndicator.createChild(am4core.Label);
            userPerformanceChartIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            userPerformanceChartIndicatorLabel.align = "center";
            userPerformanceChartIndicatorLabel.valign = "middle";
            userPerformanceChartIndicatorLabel.fontSize = 12;
            
            $.post("userPerformanceFunction.json", obj).done(function (result) {
                temp = result;
                userPerformanceChartIndicator.hide();              
                $('#userPerformanceChartWait').hide();
                $('#userPerformanceChart').show();
                
            }).always(function () {
        <c:choose>
            <c:when test="${sessionScope.performanceScoreActive}">
                var i = 0;
                var combined = [];
                var score = 0;
                var totalScore = 0;
                for (i = 0; i < temp.length; i++) {
                    totalScore += temp[i].score;
                    score = (totalScore / (i + 1)).toFixed(2);
                    combined[i] = {"date": temp[i].date, "score": score};
                }
                var userLevel = calculateUserPerformanceScoreLevel(score);
                $('#userLevel').html("<spring:message code="listFalsePositives.severity"/> " + userLevel);
                $('#userScore').html("<spring:message code="dashboard.riskScore"/> " + score);
                var progressRatio = (score - userPerformanceScoreLevelBoundries(userLevel)[0]) / (userPerformanceScoreLevelBoundries(userLevel)[1] - userPerformanceScoreLevelBoundries(userLevel)[0]) * 100;
                var bar = new ProgressBar.Circle(userLevelProgress, {
                    strokeWidth: 6,
                    easing: 'easeInOut',
                    duration: 1400,
                    color: '#FFEA82',
                    trailColor: '#eee',
                    trailWidth: 1,
                    svgStyle: null
                });

                bar.animate(progressRatio / 100);  // Number from 0.0 to 1.0
                if (0 === combined.length) {
                    userPerformanceChart.data = [];
                    //assetScoreIndicator.show();
                } else {
                    $('#userPerformanceChart').css("line-height", "");
                    userPerformanceChart.data = combined;
                    /*assetScore.dataProvider = combined;
                     assetScore.validateData();
                     assetScore.validateNow();*/
                    //assetScoreIndicator.hide();
                }
            </c:when>
            <c:otherwise>
                var i = 0;
                var combined = [];
                var score = 0;
                for (i = 0; i < temp.length; i++) {
                    score += temp[i].score;
                    combined[i] = {"date": temp[i].date, "score": temp[i].score, "early": temp[i].rightOnTimeCommit, "late": temp[i].lateCommit};
                }
                var userLevel = calculateUserSlaScoreLevel(score);
                $('#userLevel').html("<spring:message code="listFalsePositives.severity"/> " + userLevel);
                $('#userScore').html("<spring:message code="dashboard.riskScore"/> " + score);
                var progressRatio = (score - userSlaScoreLevelBoundries(userLevel)[0]) / (userSlaScoreLevelBoundries(userLevel)[1] - userSlaScoreLevelBoundries(userLevel)[0]) * 100;
                var bar = new ProgressBar.Circle(userLevelProgress, {
                    strokeWidth: 6,
                    easing: 'easeInOut',
                    duration: 1400,
                    color: '#FFEA82',
                    trailColor: '#eee',
                    trailWidth: 1,
                    svgStyle: null
                });

                bar.animate(progressRatio / 100);  // Number from 0.0 to 1.0
                if (0 === combined.length) {
                    userPerformanceChart.data = [];
                    //assetScoreIndicator.show();
                } else {
                    $('#userPerformanceChart').css("line-height", "");
                    userPerformanceChart.data = combined;
                    /*assetScore.dataProvider = combined;
                     assetScore.validateData();
                     assetScore.validateNow();*/
                    //assetScoreIndicator.hide();
                }                
            </c:otherwise>    
        </c:choose>        
            });
            $.post("ticketCount.json", obj).done(function (result) {
                temp = result;
            }).always(function () {
                statusCount = temp;
                var totalTicket = statusCount[0] + statusCount[1] + statusCount[2] + statusCount[3] + statusCount[4] + statusCount[5] + statusCount[6];
                var progressStr = '';
                if (statusCount[0] !== 0) {
                    progressStr += '<div class="progress-bar" role="progressbar" aria-valuenow="' + statusCount[0] * 100 / totalTicket + '" aria-valuemin="0" aria-valuemax="100" style="background-color:#456173; width:' + statusCount[0] * 100 / totalTicket + '%">' + '<spring:message code="genericdb.OPEN"/>' + ' : ' + statusCount[0] + '</div>';
                }
                if (statusCount[1] !== 0) {
                    progressStr += '<div class="progress-bar" role="progressbar" aria-valuenow="' + statusCount[1] * 100 / totalTicket + '" aria-valuemin="0" aria-valuemax="100" style="background-color:#1b3c59; width:' + statusCount[1] * 100 / totalTicket + '%">' + '<spring:message code="genericdb.CLOSED"/>' + ' : ' + statusCount[1] + '</div>';
                }
                if (statusCount[2] !== 0) {
                    progressStr += '<div class="progress-bar" role="progressbar" aria-valuenow="' + statusCount[2] * 100 / totalTicket + '" aria-valuemin="0" aria-valuemax="100" style="background-color:#e6b31e; width:' + statusCount[2] * 100 / totalTicket + '%">' + '<spring:message code="genericdb.RISK_ACCEPTED"/>' + ' : ' + statusCount[2] + '</div>';
                }
                if (statusCount[3] !== 0) {
                    progressStr += '<div class="progress-bar" role="progressbar" aria-valuenow="' + statusCount[3] * 100 / totalTicket + '" aria-valuemin="0" aria-valuemax="100" style="background-color:#f95959; width:' + statusCount[3] * 100 / totalTicket + '%">' + '<spring:message code="genericdb.RECHECK"/>' + ' : ' + statusCount[3] + '</div>';
                }
                if (statusCount[4] !== 0) {
                    progressStr += '<div class="progress-bar" role="progressbar" aria-valuenow="' + statusCount[4] * 100 / totalTicket + '" aria-valuemin="0" aria-valuemax="100" style="background-color:#f73859; width:' + statusCount[4] * 100 / totalTicket + '%">' + '<spring:message code="genericdb.ON_HOLD"/>' + ' : ' + statusCount[4] + '</div>';
                }
                if (statusCount[5] !== 0) {
                    progressStr += '<div class="progress-bar" role="progressbar" aria-valuenow="' + statusCount[5] * 100 / totalTicket + '" aria-valuemin="0" aria-valuemax="100" style="background-color:#f1d18a; width:' + statusCount[5] * 100 / totalTicket + '%">' + '<spring:message code="genericdb.IN_PROGRESS"/>' + ' : ' + statusCount[5] + '</div>';
                }
                if (statusCount[6] !== 0) {
                    progressStr += '<div class="progress-bar" role="progressbar" aria-valuenow="' + statusCount[6] * 100 / totalTicket + '" aria-valuemin="0" aria-valuemax="100" style="background-color:#f1d18a; width:' + statusCount[6] * 100 / totalTicket + '%">' + '<spring:message code="genericdb.FALSE_POSITIVE"/>' + ' : ' + statusCount[6] + '</div>';
                }
                $('#userTicketStatusBar').html(progressStr);
            });
            $.post("userBadges.json", obj).done(function (result) {
                temp = result;
            }).always(function () {
                for (i = 0; i < temp.length; i++) {
                    initBadge(temp[i].name);
                }
            });
        }
        <%-----------------------------------------------------     VARLIKLAR TABI     -----------------------------------------------------%>

        function assetscore() {          /////   EN RİSKLİ SİSTEMLER GRAFİĞİ   /////
            $("#assetScore").html();
            if (assetScore !== undefined) {
                assetScore.dispose();
            }
            $("#assetScoreLegendWrapper").html();
            if (assetScoreLegend !== undefined) {
                assetScoreLegend.dispose();
            }
            /* Varlık Tabı: EN RİSKLİ SİSTEMLER*/
            assetScore = am4core.create("assetScore", am4charts.PieChart3D);
            assetScore.hiddenState.properties.opacity = 0; // this creates initial fade-in
            assetScore.innerRadius = am4core.percent(40);
            assetScore.depth = 40;
            assetScore.innerRadius = 100;
            var label = assetScore.seriesContainer.createChild(am4core.Label);
            label.text = "<spring:message code="dashboard.riskScoreName"/>";
            label.horizontalCenter = "middle";
            label.verticalCenter = "middle";
            label.fontSize = 25;
            var series = assetScore.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "value";
            series.dataFields.depthValue = "value";
            series.dataFields.category = "name";
            series.ticks.template.disabled = true;
            //series.labels.template.text = "{name} | <spring:message code="dashboard.riskScore"/>:{value}";
            series.alignLabels = false;
            series.labels.template.text = "{value}";
            series.labels.template.radius = am4core.percent(10);
            series.labels.template.truncate = true;
            series.labels.template.maxWidth = 100;
            series.slices.template.cornerRadius = 5;
            series.colors.step = 3;
            series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.slices.template.interactionsEnabled = true;
            series.ticks.template.adapter.add("hidden", hideSmall);
            series.labels.template.adapter.add("hidden", hideSmall);
            function hideSmall(hidden, target) {
                return target.dataItem.values.value.percent < 5 ? true : false;
            }
            series.slices.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?assetId=' + ev.target.dataItem.dataContext.id;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            }, this);

            assetScoreLegend = am4core.create("assetScoreLegend", am4core.Container);
            assetScoreLegend.width = am4core.percent(100);
            assetScoreLegend.height = am4core.percent(100);
            assetScore.legend = new am4charts.Legend();
            assetScore.legend.parent = assetScoreLegend;
            assetScore.legend.scale = 0.6;
            assetScore.legend.fontSize = 18;

            assetScore.events.on("datavalidated", resizeLegend);
            assetScore.events.on("maxsizechanged", resizeLegend);

            function resizeLegend(ev) {
                document.getElementById("assetScoreLegend").style.height = assetScore.data.length*25 + "px";
            }

            assetScoreIndicator = assetScore.tooltipContainer.createChild(am4core.Container);
            assetScoreIndicator.background.fill = am4core.color("#fff");
            assetScoreIndicator.background.fillOpacity = 0.8;
            assetScoreIndicator.width = am4core.percent(100);
            assetScoreIndicator.height = am4core.percent(100);

            var assetScoreIndicatorLabel = assetScoreIndicator.createChild(am4core.Label);
            assetScoreIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            assetScoreIndicatorLabel.align = "center";
            assetScoreIndicatorLabel.valign = "middle";
            assetScoreIndicatorLabel.fontSize = 12;
        <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER_READONLY')">
            if (assetData !== undefined) {
                var combined = [];
                var length = 10;
                if (assetData.length < 10) {
                    length = assetData.length;
                }
                for (var i = 0; i < length; i++) {
                    var name;
                    if(assetData[i].hostname==="" || assetData[i].hostname===null ){
                         name=decodeHtml(assetData[i].ip);
                    }else{
                       name=decodeHtml(assetData[i].hostname) + ' (' + decodeHtml(assetData[i].ip) + ') ';
                   }
                    combined[i] = {"name": name, "id": assetData[i].assetId, "value": assetData[i].score};
                }
                if (0 === combined.length) {
                    assetScore.data = [];
                    assetScoreIndicator.show();
                } else {
                    $('#assetScore').css("line-height", "");
                    assetScore.data = combined;
                    document.getElementById("assetScoreLegend").style.height = assetScore.data.length*2 + "px";
                    assetScoreIndicator.hide();

                }
                $("#mostRiskySystemsWait").hide();
                $("#assetScore").show();
            }
        </sec:authorize>
        <sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY')">
            var obj = getObjectByForm("searchForm");
            var temp;
            $.post("assetscore.json", obj).done(function (result) {
                temp = result;
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            }).always(function () {
                var i = 0;
                var combined = [];
                for (i = 0; i < temp.length; i++) {
                    combined[i] = {"name": decodeHtml(temp[i].ip), "id": temp[i].assetId, "value": temp[i].score};
                }
                if (0 === combined.length) {
                    assetScore.data = [];
                    assetScoreIndicator.show();
                } else {
                    $('#assetScore').css("line-height", "");
                    assetScore.data = combined;
                    assetScoreIndicator.hide();

                }
                $("#mostRiskySystemsWait").hide();
                $("#assetScore").show();
            });
            </sec:authorize>
        </sec:authorize>
        }
        function top10ip() {      /////   EN ÇOK ZAFİYETE SAHİP 10 IP GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            obj["limit"] = 10;
            $("#top10ipgraph").html();
            if (top10ipgraph !== undefined)
                top10ipgraph.dispose();
            /* Varlık Tabı: EN ÇOK ZAFİYETE SAHİP 10 IP*/
            top10ipgraph = am4core.create("top10ipgraph", am4charts.RadarChart);
            top10ipgraph.data = [];

            /* Create axes */
            var categoryAxis = top10ipgraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";

            var valueAxis = top10ipgraph.yAxes.push(new am4charts.ValueAxis());
            valueAxis.extraMin = 0.2;
            valueAxis.extraMax = 0.2;
            valueAxis.tooltip.disabled = true;

            /* Create and configure series */
            var series1 = top10ipgraph.series.push(new am4charts.RadarSeries());
            series1.dataFields.valueY = "value";
            series1.dataFields.categoryX = "name";
            series1.strokeWidth = 3;
            series1.tooltipText = "{valueY}";
            var bullet = series1.bullets.create(am4charts.CircleBullet);
            top10ipgraph.interactionsEnabled = true;
            bullet.events.on("hit", function(ev) {
                var url = '../customer/listVulnerabilities.htm?assetId=' + ev.target.dataItem.dataContext.id;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
              });
            top10ipgraph.cursor = new am4charts.RadarCursor();

            top10ipIndicator = top10ipgraph.tooltipContainer.createChild(am4core.Container);
            top10ipIndicator.background.fill = am4core.color("#fff");
            top10ipIndicator.background.fillOpacity = 0.8;
            top10ipIndicator.width = am4core.percent(100);
            top10ipIndicator.height = am4core.percent(100);

            var top10ipIndicatorLabel = top10ipIndicator.createChild(am4core.Label);
            top10ipIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            top10ipIndicatorLabel.align = "center";
            top10ipIndicatorLabel.valign = "middle";
            top10ipIndicatorLabel.fontSize = 12;
            $.post("top10ip.json", obj).done(function (result) {
                temp = result;
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            }).always(function () {
                var i = 0;
                var combined = [];
                var name; 
                    
                for (i = 0; i < temp.length; i++) {
                     if(temp[i].hostname==="" || temp[i].hostname===null ){
                         
                         name=decodeHtml(temp[i].ip);
                    }else{
                       name=temp[i].hostname;
                   }
                    combined[i] = {"name": name, "id": temp[i].assetId, "value": temp[i].vulnerabilityCount};
                }
                if (0 === combined.length) {
                    var emptyData = [];
                    emptyData[0] = {"name": "", "id": "", "value": 0};
                    top10ipgraph.data = emptyData;
                    top10ipIndicator.show();
                } else {
                    $('#top10ipgraph').css("line-height", "");
                    top10ipgraph.data = combined;
                    top10ipIndicator.hide();
                }             
                    $("#top10weaknessWait").hide();
                    $("#top10ipgraph").show();
            });                          
        }
        function assetvuln() {          /////   RİSK SEVİYESİNE GÖRE VARLIKLARIN DAĞILIMI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#assetrisk").html();
            if (assetrisk !== undefined)
                assetrisk.dispose();
            /* Varlık Tabı: RİSK SEVİYESİNE GÖRE VARLIKLARIN DAĞILIMI*/
            assetrisk = am4core.create("assetrisk", am4charts.PieChart3D);
            assetrisk.hiddenState.properties.opacity = 0; // this creates initial fade-in

            assetrisk.data = [];
            var series = assetrisk.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "value";
            series.dataFields.category = "name";
            series.colors.list = [
                new am4core.color('#F9FABB'),
                new am4core.color('#FEFE60'),
                new am4core.color('#F8C508'),
                new am4core.color('#F88008'),
                new am4core.color('#D91E18')
            ];

            series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.ticks.template.adapter.add("hidden", hideSmall);
            series.labels.template.adapter.add("hidden", hideSmall);
            function hideSmall(hidden, target) {
                return target.dataItem.values.value.percent <= 0 ? true : false;
            }
            series.slices.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?level=' + ev.target.dataItem.dataContext.riskLevel;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            }, this);

            assetriskIndicator = assetrisk.tooltipContainer.createChild(am4core.Container);
            assetriskIndicator.background.fill = am4core.color("#fff");
            assetriskIndicator.background.fillOpacity = 0.8;
            assetriskIndicator.width = am4core.percent(100);
            assetriskIndicator.height = am4core.percent(100);

            var assetriskIndicatorLabel = assetriskIndicator.createChild(am4core.Label);
            assetriskIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            assetriskIndicatorLabel.align = "center";
            assetriskIndicatorLabel.valign = "middle";
            assetriskIndicatorLabel.fontSize = 12;

                $.post("assetvuln.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            if (0 === temp[0] && 0 === temp[1] && 0 === temp[2] && 0 === temp[3] && 0 === temp[4]) {
                /*  $('#assetrisk').removeAttr('style');
                 $('#assetrisk').css("text-align", "center");
                 $('#assetrisk').css("width:", "100%");
                 $('#assetrisk').css("height", "400px");
                 $('#assetrisk').css("line-height", "400px");
                 $('#assetrisk').text("<spring:message code="generic.emptyGraph"/>"); */
                assetrisk.data = [];
                assetriskIndicator.show();
            } else {
                $('#assetrisk').css("line-height", "");
                var dataSub = [{
                        "name": decodeHtml("<spring:message code="dashboard.level1"/>"),
                        "value": 0, "riskLevel": 1, "color": '#F9FABB'
                    }, {
                        "name": decodeHtml("<spring:message code="dashboard.level2"/>"),
                        "value": 0, "riskLevel": 2, "color": '#FEFE60'
                    }, {
                        "name": decodeHtml("<spring:message code="dashboard.level3"/>"),
                        "value": 0, "riskLevel": 3, "color": '#F8C508'
                    }, {
                        "name": decodeHtml("<spring:message code="dashboard.level4"/>"),
                        "value": 0, "riskLevel": 4, "color": '#F88008'
                    }, {
                        "name": decodeHtml("<spring:message code="dashboard.level5"/>"),
                        "value": 0, "riskLevel": 5, "color": '#D91E18'
                    }];
                dataSub[0].value = temp[4];
                dataSub[1].value = temp[3];
                dataSub[2].value = temp[2];
                dataSub[3].value = temp[1];
                dataSub[4].value = temp[0];
                assetrisk.data = dataSub;
                //assetrisk.validateData();
                //assetrisk.validateNow();
                assetriskIndicator.hide();
            }
               
                $("#accordingToRiskLevelsWait").hide();
                $("#assetrisk").show();

            });
        }
        function assetgroupsfunction() {        /////   VARLIK GRUPLARINA GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#assetgroupsvuln").html();
            if (assetgroupsvuln !== undefined)
                assetgroupsvuln.dispose();
            /* Varlık Tabı: VARLIK GRUPLARINA GÖRE ZAFİYETLERİN DAĞILIMI*/
            assetgroupsvuln = am4core.create("assetgroupsvuln", am4charts.XYChart);
            assetgroupsvuln.data = [];

            // Create axes
            var categoryAxis = assetgroupsvuln.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";
            categoryAxis.renderer.grid.template.location = 0;
            // Configure axis label
            var label = categoryAxis.renderer.labels.template;
            label.wrap = true;

            var valueAxis = assetgroupsvuln.yAxes.push(new am4charts.ValueAxis());
            valueAxis.renderer.inside = true;
            valueAxis.renderer.labels.template.disabled = true;
            valueAxis.min = 0;
            valueAxis.calculateTotals = true;

            // Create series
            function createSeries(field, name) {

                // Set up series
                var series = assetgroupsvuln.series.push(new am4charts.ColumnSeries());
                series.name = name;
                series.dataFields.valueY = field;
                series.dataFields.categoryX = "name";
                series.sequencedInterpolation = true;
                series.stroke = am4core.color("#ffffff");
                if (field === 'level1')
                    series.columns.template.fill = am4core.color("#F9FABB");
                else if (field === 'level2')
                    series.columns.template.fill = am4core.color("#FEFE60");
                else if (field === 'level3')
                    series.columns.template.fill = am4core.color("#F8C508");
                else if (field === 'level4')
                    series.columns.template.fill = am4core.color("#F88008");
                else if (field === 'level5')
                    series.columns.template.fill = am4core.color("#D91E18");
                // Make it stacked
                series.stacked = true;

                // Configure columns
                series.columns.template.width = am4core.percent(60);
                series.columns.template.tooltipText = "[bold]{categoryX}[/]\n[font-size:14px]" + series.name + ": {valueY}";

                // Add label
                var labelBullet = series.bullets.push(new am4charts.LabelBullet());
                if (field === "level5") {
                    labelBullet.label.text = "{valueY.total}";
                    labelBullet.label.verticalCenter = "bottom";
                    assetgroupsvuln.maskBullets = false;
                }
                labelBullet.label.adapter.add("hidden", hideSmall);
                function hideSmall(hidden, target) {
                    if (target.dataItem.values.valueY.total === 0) {
                        target.hidden = true;
                        return true;
                    }
                    return false;
                }
                series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                series.columns.template.events.on("hit", function (ev) {
                    var url = '../customer/listVulnerabilities.htm?groupId=' + ev.target.dataItem.dataContext.id;
                    switch (ev.target.dom.attributes['fill'].nodeValue) {
                        case ev.target.dataItem.dataContext.color1:
                            url += '&level=1';
                            break;
                        case ev.target.dataItem.dataContext.color2:
                            url += '&level=2';
                            break;
                        case ev.target.dataItem.dataContext.color3:
                            url += '&level=3';
                            break;
                        case ev.target.dataItem.dataContext.color4:
                            url += '&level=4';
                            break;
                        case ev.target.dataItem.dataContext.color5:
                            url += '&level=5';
                            break;
                        default:
                            break;
                    }
                    url = addFilterToUrl(url);
                    window.open(url, '_blank');
                }, this);
                return series;
            }
            createSeries("level1", "<spring:message code="dashboard.level1"/>");
            createSeries("level2", "<spring:message code="dashboard.level2"/>");
            createSeries("level3", "<spring:message code="dashboard.level3"/>");
            createSeries("level4", "<spring:message code="dashboard.level4"/>");
            createSeries("level5", "<spring:message code="dashboard.level5"/>");


            assetgroupsvulnIndicator = assetgroupsvuln.tooltipContainer.createChild(am4core.Container);
            assetgroupsvulnIndicator.background.fill = am4core.color("#fff");
            assetgroupsvulnIndicator.background.fillOpacity = 0.8;
            assetgroupsvulnIndicator.width = am4core.percent(100);
            assetgroupsvulnIndicator.height = am4core.percent(100);

            var assetgroupsvulnIndicatorLabel = assetgroupsvulnIndicator.createChild(am4core.Label);
            assetgroupsvulnIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            assetgroupsvulnIndicatorLabel.align = "center";
            assetgroupsvulnIndicatorLabel.valign = "middle";
            assetgroupsvulnIndicatorLabel.fontSize = 12;
            $.post("assetgroupsvuln.json", obj).done(function (result) {
                temp = result;
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            }).always(function () {
            var countslevel1 = [];
            var countslevel2 = [];
            var countslevel3 = [];
            var countslevel4 = [];
            var countslevel5 = [];
            var groupnames = [];
            var groupIds = [];
            var assetgroupvalues = [];
            for (var i = 0; i < temp.length; i++) {
                countslevel1[i] = {name: decodeHtml(temp[i].name), y: temp[i].level1Count};
                countslevel2[i] = {name: decodeHtml(temp[i].name), y: temp[i].level2Count};
                countslevel3[i] = {name: decodeHtml(temp[i].name), y: temp[i].level3Count};
                countslevel4[i] = {name: decodeHtml(temp[i].name), y: temp[i].level4Count};
                countslevel5[i] = {name: decodeHtml(temp[i].name), y: temp[i].level5Count};
                groupnames[i] = decodeHtml(temp[i].name) + "\n" + "<spring:message code="dashboard.averageRisk"/>: " + "\n" + temp[i].score;
                groupIds[i] = temp[i].groupId;
            }
            for (var s = 0; s < groupnames.length; s++) {
                assetgroupvalues[s] = {"name": groupnames[s], "id": groupIds[s], "level5": countslevel5[s].y, "level4": countslevel4[s].y,
                    "level3": countslevel3[s].y, "level2": countslevel2[s].y, "level1": countslevel1[s].y,
                    "color5": '#d91e18',
                    "color4": '#f88008',
                    "color3": '#f8c508',
                    "color2": '#fefe60',
                    "color1": '#f9fabb'};
            }
            if (1 === assetgroupvalues.length && temp[0].score === 0) {
                /*   $('#assetgroupsvuln').removeAttr('style');
                 $('#assetgroupsvuln').css("text-align", "center");
                 $('#assetgroupsvuln').css("width:", "100%");
                 $('#assetgroupsvuln').css("height", "400px");
                 $('#assetgroupsvuln').css("line-height", "400px");
                 $('#assetgroupsvuln').text("<spring:message code="generic.emptyGraph"/>");  */
                assetgroupsvuln.data = [];
                assetgroupsvulnIndicator.show();
            } else {
                $('#assetgroupsvuln').css("line-height", "");
                assetgroupsvuln.data = assetgroupvalues;
                /*assetgroupsvuln.dataProvider = assetgroupvalues;
                 assetgroupsvuln.validateData();
                 assetgroupsvuln.animateAgain();
                 assetgroupsvuln.invalidateSize();*/
                assetgroupsvulnIndicator.hide();

            }
                
                $("#accordingToAssetGroup").hide();
                $("#assetgroupsvuln").show();

                
            });
            
        }

        //-----------------------------------------------------     RİSK METRE TABI     -----------------------------------------------------//

        function vulnDayFunction() {                /////   ZAFİYET GRAFİĞİ  /////
            $('#vulnDayGraph').hide();
            var obj = getObjectByForm("searchForm");
            var timeInterval = $("label[for='options'].active")[0].firstElementChild.defaultValue;
            obj["timeInterval"] = timeInterval;
                $.post("dailyVuln.json", obj).done(function (result) {
                /* Risk Metre: ZAFİYET GRAFİĞİ*/
            $("#vulnDayGraph").html();
            if (vulnDayGraph !== undefined)
                vulnDayGraph.dispose();
            vulnDayGraph = am4core.create("vulnDayGraph", am4charts.XYChart3D);
            // Create axes
            var categoryAxis = vulnDayGraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "country";
            categoryAxis.renderer.grid.template.location = 0;
            categoryAxis.renderer.opposite = "true";
            categoryAxis.renderer.minGridDistance = "50";
            categoryAxis.renderer.labels.template.rotation = "270";

            vulnDayGraph.scrollbarX = new am4core.Scrollbar();
            vulnDayGraph.scrollbarX.parent = vulnDayGraph.bottomAxesContainer;

            var valueAxis = vulnDayGraph.yAxes.push(new am4charts.ValueAxis());
            valueAxis.renderer.inside = false;
            valueAxis.renderer.labels.template.disabled = false;
            valueAxis.min = 0;
            valueAxis.calculateTotals = true;
            // Create seriese
            function createvulnDayGraphSeries(field, name) {
                // Set up series
                var series = vulnDayGraph.series.push(new am4charts.ColumnSeries3D());
                series.name = name;
                series.dataFields.valueY = field;
                series.columns.template.fillOpacity = .8;
                series.dataFields.categoryX = "country";
                series.stroke = am4core.color("#ffffff");
                if (field === 'openVuln1')
                    series.columns.template.fill = am4core.color("#F9FABB");
                else if (field === 'openVuln2')
                    series.columns.template.fill = am4core.color("#FEFE60");
                else if (field === 'openVuln3')
                    series.columns.template.fill = am4core.color("#F8C508");
                else if (field === 'openVuln4')
                    series.columns.template.fill = am4core.color("#F88008");
                else if (field === 'openVuln5')
                    series.columns.template.fill = am4core.color("#D91E18");
                series.sequencedInterpolation = true;
                // Make it stacked
                series.stacked = true;
                // Configure columns
                series.columns.template.width = am4core.percent(100);
                series.columns.template.tooltipText = "[bold]{name}[/]\n[font-size:14px]{categoryX}: {valueY}";
                // Add label
                if (field === "openVuln5") {
                    var labelBullet = series.bullets.push(new am4charts.LabelBullet());
                    labelBullet.label.text = "[font-size: 15px]{valueY.total}[/]";
                    labelBullet.label.dy = -15;
                    labelBullet.label.verticalCenter = "bottom";
                    vulnDayGraph.maskBullets = false;
                    labelBullet.label.adapter.add("hidden", hideSmall);
                }

                return series;
            }
            function hideSmall(hidden, target) {
                if (target.dataItem.values.valueY.total === 0) {
                    return true;
                }
                return false;
            }
            createvulnDayGraphSeries("openVuln1", "<spring:message code="dashboard.level1"/>");
            createvulnDayGraphSeries("openVuln2", "<spring:message code="dashboard.level2"/>");
            createvulnDayGraphSeries("openVuln3", "<spring:message code="dashboard.level3"/>");
            createvulnDayGraphSeries("openVuln4", "<spring:message code="dashboard.level4"/>");
            createvulnDayGraphSeries("openVuln5", "<spring:message code="dashboard.level5"/>");
            vulnDayGraph.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            vulnDayIndicator = vulnDayGraph.tooltipContainer.createChild(am4core.Container);
            vulnDayIndicator.background.fill = am4core.color("#fff");
            vulnDayIndicator.background.fillOpacity = 0.8;
            vulnDayIndicator.width = am4core.percent(100);
            vulnDayIndicator.height = am4core.percent(100);

            var vulnDayIndicatorLabel = vulnDayIndicator.createChild(am4core.Label);
            vulnDayIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            vulnDayIndicatorLabel.align = "center";
            vulnDayIndicatorLabel.valign = "middle";
            vulnDayIndicatorLabel.fontSize = 12;
            var last3months = result[0].last3months;
            var graphValues = [];
            var list = result[0].days;
            for (var x = 0; x < list.length; x++) {
                graphValues.push({
                    "country": list[x],
                    "openVuln1": last3months[x][4],
                    "openVuln2": last3months[x][3],
                    "openVuln3": last3months[x][2],
                    "openVuln4": last3months[x][1],
                    "openVuln5": last3months[x][0],
                    "blank": 1,
                    "color5": '#D91E18',
                    "color4": '#F88008',
                    "color3": '#F8C508',
                    "color2": '#FEFE60',
                    "color1": '#F9FABB',
                    "colorx": '#FFFFFF'
                });
            }
            var remove = result.length - 93;
            /* for (var a = 0; a < remove; a++) {
             vulnDayGraph.shift();
             }*/
            vulnDayGraph.data = graphValues;
            vulnDayIndicator.hide();
            //vulnDayGraph.dataProvider = graphValues;
            //vulnDayGraph.validateData();
            $('#vulnDayGraph').css("width:", "100%");
            $('#vulnDayGraph').css("height", "500px");
            $('#vulnDayGraphWait').hide();
            $('#vulnDayGraph').show();
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
        }
            }).always(function () {
                var values = vulnDayGraph.data;
                vulnDayGraph.zoomToIndexes(values.length - 31, values.length);
            });
        }
        function vulnDayTotalFunction() {                 /////   ZAFİYET GRAFİĞİ (KÜMÜLATİF)   /////
            $('#vulnDayGraphTotal').hide();
            $('#vulnDayGraphTotalWait').show();
            var obj = getObjectByForm("searchForm");
            var timeInterval = $("label[for='options'].active")[0].firstElementChild.defaultValue;
            obj["timeInterval"] = timeInterval;
            $("#vulnDayGraphTotal").html();
            if (vulnDayGraphTotal !== undefined)
                vulnDayGraphTotal.dispose();
            /* Risk Metre: ZAFİYET GRAFİĞİ (KÜMÜLATİF)*/
            vulnDayGraphTotal = am4core.create("vulnDayGraphTotal", am4charts.XYChart);

            // Create axes
            var categoryAxis = vulnDayGraphTotal.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "category";
            categoryAxis.renderer.opposite = "true";
            categoryAxis.renderer.minGridDistance = "50";
            categoryAxis.renderer.labels.template.rotation = "270";

            vulnDayGraphTotal.scrollbarX = new am4core.Scrollbar();
            vulnDayGraphTotal.scrollbarX.parent = vulnDayGraphTotal.bottomAxesContainer;

            var valueAxis = vulnDayGraphTotal.yAxes.push(new am4charts.ValueAxis());
            valueAxis.renderer.inside = false;
            valueAxis.renderer.labels.template.disabled = false;
            valueAxis.min = 0;
            vulnDayGraphTotal.cursor = new am4charts.XYCursor();
            vulnDayGraphTotal.cursor.xAxis = valueAxis;
            vulnDayGraphTotal.cursor.lineX.disabled = true;

            // Create series
            function createvulnDayGraphTotalSeries(field, name) {
                // Set up series
                var seriesVulnDayGraphTotal = vulnDayGraphTotal.series.push(new am4charts.LineSeries());
                seriesVulnDayGraphTotal.dataFields.categoryX = "category";
                seriesVulnDayGraphTotal.name = name;
                seriesVulnDayGraphTotal.dataFields.valueY = field;
                seriesVulnDayGraphTotal.tooltipText = "[bold]{name}[/]:[font-size:14px]{valueY}";
                seriesVulnDayGraphTotal.fillOpacity = 0.8;
                seriesVulnDayGraphTotal.strokeWidth = 2;
                seriesVulnDayGraphTotal.stacked = true;
                seriesVulnDayGraphTotal.sequencedInterpolariton = true;
                if (field === 'openVuln1') {
                    seriesVulnDayGraphTotal.stroke = am4core.color("#F9FABB");
                    seriesVulnDayGraphTotal.fill = am4core.color("#F9FABB");
                } else if (field === 'openVuln2') {
                    seriesVulnDayGraphTotal.stroke = am4core.color("#FEFE60");
                    seriesVulnDayGraphTotal.fill = am4core.color("#FEFE60");
                } else if (field === 'openVuln3') {
                    seriesVulnDayGraphTotal.stroke = am4core.color("#F8C508");
                    seriesVulnDayGraphTotal.fill = am4core.color("#F8C508");
                } else if (field === 'openVuln4') {
                    seriesVulnDayGraphTotal.stroke = am4core.color("#F88008");
                    seriesVulnDayGraphTotal.fill = am4core.color("#F88008");
                } else if (field === 'openVuln5') {
                    seriesVulnDayGraphTotal.stroke = am4core.color("#D91E18");
                    seriesVulnDayGraphTotal.fill = am4core.color("#D91E18");
                }
                return seriesVulnDayGraphTotal;
            }
            createvulnDayGraphTotalSeries("openVuln1", "<spring:message code="dashboard.level1"/>");
            createvulnDayGraphTotalSeries("openVuln2", "<spring:message code="dashboard.level2"/>");
            createvulnDayGraphTotalSeries("openVuln3", "<spring:message code="dashboard.level3"/>");
            createvulnDayGraphTotalSeries("openVuln4", "<spring:message code="dashboard.level4"/>");
            createvulnDayGraphTotalSeries("openVuln5", "<spring:message code="dashboard.level5"/>");
            vulnDayGraphTotal.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            var graphValues = [];
            if (timeInterval === "0" && dailyVulnCountData !== undefined) {
                for (var x = 0; x < dailyVulnCountData.length; x++) {
                    graphValues.push({
                        "category": dailyVulnCountData[x].date,
                        "openVuln1": dailyVulnCountData[x].level1count,
                        "openVuln2": dailyVulnCountData[x].level2count,
                        "openVuln3": dailyVulnCountData[x].level3count,
                        "openVuln4": dailyVulnCountData[x].level4count,
                        "openVuln5": dailyVulnCountData[x].level5count,
                        "blank": 1,
                        "color5": '#D91E18',
                        "color4": '#F88008',
                        "color3": '#F8C508',
                        "color2": '#FEFE60',
                        "color1": '#F9FABB',
                        "colorx": '#FFFFFF'
                    });
                }
                x--;
                vulnDayGraphTotal.data = graphValues;
                //vulnDayGraphTotal.validateData();
                $('#vulnDayGraphTotal').css("width:", "100%");
                $('#vulnDayGraphTotal').css("height", "285px");
                if(dailyVulnCountData.length>0){
                valueAxis.max = 200+dailyVulnCountData[x].level1count+dailyVulnCountData[x].level2count+dailyVulnCountData[x].level3count+dailyVulnCountData[x].level4count+dailyVulnCountData[x].level5count;
                }
                $('#vulnDayGraphTotalWait').hide();
                $('#vulnDayGraphTotal').show();
            } else {            
                $.post("dailyVulnTotal.json", obj).done(function (result) {
                    var x;
                    for (x = 0; x < result.length; x++) {
                        graphValues.push({
                            "category": result[x].date,
                            "openVuln1": result[x].level1count,
                            "openVuln2": result[x].level2count,
                            "openVuln3": result[x].level3count,
                            "openVuln4": result[x].level4count,
                            "openVuln5": result[x].level5count,
                            "blank": 1,
                            "color5": '#D91E18',
                            "color4": '#F88008',
                            "color3": '#F8C508',
                            "color2": '#FEFE60',
                            "color1": '#F9FABB',
                            "colorx": '#FFFFFF'
                        });
                    }
                    x--;
                    vulnDayGraphTotal.data = graphValues;
                    //vulnDayGraphTotal.validateData();
                    $('#vulnDayGraphTotal').css("width:", "100%");
                    $('#vulnDayGraphTotal').css("height", "283px");
                    if(result.length>0){
                    valueAxis.max = 200+result[x].level1count+result[x].level2count+result[x].level3count+result[x].level4count+result[x].level5count;
                    }
                    $('#vulnDayGraphTotalWait').hide();
                    $('#vulnDayGraphTotal').show();
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    //var temp = vulnDayGraphTotal.dataProvider;
                    //vulnDayGraphTotal.zoomToIndexes(temp.length - 31, temp.length);
                });
            }
        }
        function vulnDayStatusFunction() {        /////   AÇIK VE KAPALI ZAFİYET GRAFİĞİ (KÜMÜLATİF)   /////
            $('#vulnDayGraphStatus').hide();
            $('#vulnDayGraphStatusWait').show();
            var obj = getObjectByForm("searchForm");
            var timeInterval = $("label[for='options'].active")[0].firstElementChild.defaultValue;
            obj["timeInterval"] = timeInterval;
            $("#vulnDayGraphStatus").html();
            if (vulnDayGraphStatus !== undefined)
                vulnDayGraphStatus.dispose();
            /* Risk Metre:  AÇIK VE KAPALI ZAFİYET GRAFİĞİ (KÜMÜLATİF)*/
            vulnDayGraphStatus = am4core.create("vulnDayGraphStatus", am4charts.XYChart);

            // Create axes
            var categoryAxis = vulnDayGraphStatus.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "date";
            categoryAxis.renderer.opposite = "true";
            categoryAxis.renderer.minGridDistance = "50";
            categoryAxis.renderer.labels.template.rotation = "270";

            vulnDayGraphStatus.scrollbarX = new am4core.Scrollbar();
            vulnDayGraphStatus.scrollbarX.parent = vulnDayGraphStatus.bottomAxesContainer;

            var valueAxis = vulnDayGraphStatus.yAxes.push(new am4charts.ValueAxis());
            valueAxis.renderer.inside = false;
            valueAxis.renderer.labels.template.disabled = false;
            valueAxis.min = 0;
            vulnDayGraphStatus.cursor = new am4charts.XYCursor();
            vulnDayGraphStatus.cursor.xAxis = valueAxis;
            vulnDayGraphStatus.cursor.lineX.disabled = true;

            // Create series
            function createvulnDayGraphStatusSeries(field, name) {
                // Set up series
                var series = vulnDayGraphStatus.series.push(new am4charts.LineSeries());
                series.dataFields.categoryX = "date";
                series.name = name;
                series.dataFields.valueY = field;
                series.tooltipText = "[bold]{name}[/]:[font-size:14px]{valueY}";
                series.fillOpacity = 0.8;
                series.strokeWidth = 2;
                series.stacked = true;
                series.sequencedInterpolariton = true;
                if (field === 'open') {
                    series.stroke = am4core.color("#D91E18");
                    series.fill = am4core.color("#D91E18");
                } else if (field === 'close') {
                    series.stroke = am4core.color("#4682B4");
                    series.fill = am4core.color("#4682B4");
                }
                return series;
            }
            createvulnDayGraphStatusSeries("open", "<spring:message code="dashboard.open"/>");
            createvulnDayGraphStatusSeries("close", "<spring:message code="dashboard.closed"/>");
            vulnDayGraphStatus.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            var graphValues = [];
            $.post("dailyVulnStatus.json", obj).done(function (result) {               
                for (var x = 0; x < result.length; x++) {
                    graphValues.push({
                        "date": result[x].date,
                        "open": result[x].level5count,
                        "close": result[x].level4count,
                        "blank": 1,
                        "colorOpen": '#D91E18',
                        "colorClose": '#4682B4',
                        "colorx": '#FFFFFF'
                    });
                }
                vulnDayGraphStatus.data = graphValues;
                //vulnDayGraphStatus.validateData();
                $('#vulnDayGraphStatus').css("width:", "100%");
                $('#vulnDayGraphStatus').css("height", "500px");
                $('#vulnDayGraphStatusWait').hide();
                $('#vulnDayGraphStatus').show();
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            }).always(function () {
                //var temp = vulnDayGraphStatus.dataProvider;
                //vulnDayGraphStatus.zoomToIndexes(temp.length - 31, temp.length);
            });
        }
        function heatMapFunction() {        /////   GÜNLÜK ZAFİYET GRAFİĞİ (HEATMAP)   /////
            $('#heatMap').hide();
            $('#heatMapWait').show();
            var obj = getObjectByForm("searchForm");

            $("#heatMap").html();
            if (heatMap !== undefined)
                heatMap.dispose();
            //heatmap
            heatMap = am4core.create("heatMap", am4charts.XYChart);
            heatMap.maskBullets = false;

            var xAxis = heatMap.xAxes.push(new am4charts.CategoryAxis());
            var yAxis = heatMap.yAxes.push(new am4charts.CategoryAxis());

            xAxis.dataFields.category = "day";
            yAxis.dataFields.category = "month";

            xAxis.renderer.grid.template.disabled = true;
            xAxis.renderer.minGridDistance = 40;

            yAxis.renderer.grid.template.disabled = true;
            yAxis.renderer.minGridDistance = 30;

            var series = heatMap.series.push(new am4charts.ColumnSeries());
            series.dataFields.categoryX = "day";
            series.dataFields.categoryY = "month";
            series.dataFields.value = "value";
            series.sequencedInterpolation = true;
            series.defaultState.transitionDuration = 3000;

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#ffffff");
            columnTemplate.tooltipText = "{day} {month} | <spring:message code="dashboard.alarmLevel"/>:{value.workingValue.formatNumber('#.')}";
            columnTemplate.width = am4core.percent(100);
            columnTemplate.height = am4core.percent(100);
            columnTemplate.propertyFields.fill = "color";
                $.post("heatMapGraph.json", obj).done(function (result) {
            var last3months = result[0].last3months;
            var days = result[0].days;
            var months = result[0].months;
            var last3monthsheat = [];
            for (var j = 0; j < last3months.length; j++) {
                if (last3months[j][0] > 0) {
                    last3monthsheat[j] = 5;
                } else {
                    if (last3months[j][1] > 0) {
                        last3monthsheat[j] = 4;
                    } else {
                        if (last3months[j][2] > 0) {
                            last3monthsheat[j] = 3;
                        } else {
                            if (last3months[j][3] > 0) {
                                last3monthsheat[j] = 2;
                            } else {
                                if (last3months[j][4] > 0) {
                                    last3monthsheat[j] = 1;
                                } else {
                                    last3monthsheat[j] = 0;
                                }
                            }
                        }
                    }
                }
            }
            var sourceData = [];
            var firstmonth;
            var secondmonth;
            var thirdmonth;
            for (var i = 0; i < 31; i++) {
                var newDate = i + 1;
                var dataPoint = {
                    date: newDate
                };
                var x = days[92];
                var s = i + 1;
                var y = x.substring(0, 7);
                if (s < 10) {
                    firstmonth = y + '-0' + s;
                } else
                    firstmonth = y + '-' + s;
                var a = days.indexOf(firstmonth);
                var t = x.substring(5, 7);
                t = t - 1;
                if (t < 10) {
                    if (t === 0) {
                        var year = x.substring(0, 4) - 1;
                        if (s < 10) {
                            secondmonth = year + "-12-0" + s;
                        } else
                            secondmonth = year + "-12-" + s;
                    } else {
                        if (s < 10) {
                            secondmonth = x.substring(0, 5) + "0" + t + "-0" + s;
                        } else
                            secondmonth = x.substring(0, 5) + "0" + t + "-" + s;
                    }
                } else {
                    if (s < 10) {
                        secondmonth = x.substring(0, 5) + t + "-0" + s;
                    } else
                        secondmonth = x.substring(0, 5) + t + "-" + s;
                }
                var b = days.indexOf(secondmonth);
                var t = x.substring(5, 7);
                t = t - 2;
                if (t < 10) {
                    if (t === 0) {
                        var year = x.substring(0, 4) - 1;
                        if (s < 10) {
                            thirdmonth = year + "-12-0" + s;
                        } else
                            thirdmonth = year + "-12-" + s;
                    } else if (t === -1) {
                        var year = x.substring(0, 4) - 1;
                        if (s < 10) {
                            thirdmonth = year + "-11-0" + s;
                        } else
                            thirdmonth = year + "-11-" + s;
                    } else {
                        if (s < 10) {
                            thirdmonth = x.substring(0, 5) + "0" + t + "-0" + s;
                        } else
                            thirdmonth = x.substring(0, 5) + "0" + t + "-" + s;
                    }
                } else {
                    if (s < 10) {
                        thirdmonth = x.substring(0, 5) + t + "-0" + s;
                    } else
                        thirdmonth = x.substring(0, 5) + t + "-" + s;
                }
                var c = days.indexOf(thirdmonth);
                for (var h = 1; h <= 3; h++) {
                    if (h === 1 && a !== -1) {
                        dataPoint['value' + h] = last3monthsheat[a];
                    } else {
                        dataPoint['value' + h] = 6;
                    }
                    if (h === 2 && b !== -1) {
                        dataPoint['value' + h] = last3monthsheat[b];
                    }
                    if (h === 3 && c !== -1) {
                        dataPoint['value' + h] = last3monthsheat[c];
                    }
                }
                sourceData.push(dataPoint);
            }
            firstmonthHeat = firstmonth;
            secondmonthHeat = secondmonth;
            thirdmonthHeat = thirdmonth;
            var colors = ['#FFFFE4', '#F9FABB', '#FEFE60', '#F8C508', '#F88008', '#D91E18', '#FFFFFF'];
            for (i in sourceData) {
                for (var h = 1; h <= 3; h++) {
                    sourceData[i]['color' + h] = colors[sourceData[i]['value' + h]];
                    sourceData[i]['hour' + h] = 1;
                }
            }

            var graphs = [];
            for (var h = 1; h <= 3; h++) {
                graphs.push({
                    "showBalloon": false,
                    "fillAlphas": 1,
                    "lineAlpha": 0,
                    "type": "column",
                    "colorField": "color" + h,
                    "valueField": "hour" + h
                });
            }
            graphsHeat = graphs;
            sourceDataHeat = sourceData;
            monthsHeat = months;
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
        }
            }).always(function () {
            var combinedgraph = [];
            var count = 0;
            const monthNamesEn = ["January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"];
            const monthNamesTr = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
                "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
            function getRiskColor(risk) {
                if (risk === 0)
                    return "#fbfcd3";
                else if (risk === 1)
                    return "#F9FABB";
                else if (risk === 2)
                    return "#FEFE60";
                else if (risk === 3)
                    return "#F8C508";
                else if (risk === 4)
                    return "#F88008";
                else if (risk === 5)
                    return "#D91E18";
            }
    <c:choose>
        <c:when test="${selectedLanguage == 'en'}">
            for (var s = 0; s < sourceDataHeat.length; s++) {
                var dayObject = new Date();
                if (sourceDataHeat[s].value1 !== 6)
                    combinedgraph[count + 2] = {"month": monthNamesEn[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": sourceDataHeat[s].value1, "color": getRiskColor(sourceDataHeat[s].value1)};
                else
                    combinedgraph[count + 2] = {"month": monthNamesEn[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": null, "color": "#ffffff"};
                dayObject.setMonth(dayObject.getMonth() - 1);
                if (sourceDataHeat[s].value2 !== 6)
                    combinedgraph[count + 1] = {"month": monthNamesEn[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": sourceDataHeat[s].value2, "color": getRiskColor(sourceDataHeat[s].value2)};
                else
                    combinedgraph[count + 1] = {"month": monthNamesEn[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": null, "color": "#ffffff"};
                dayObject.setMonth(dayObject.getMonth() - 1);
                if (sourceDataHeat[s].value3 !== 6)
                    combinedgraph[count] = {"month": monthNamesEn[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": sourceDataHeat[s].value3, "color": getRiskColor(sourceDataHeat[s].value3)};
                else
                    combinedgraph[count] = {"month": monthNamesEn[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": null, "color": "#ffffff"};
                count = count + 3;
            }
        </c:when>
        <c:when test="${selectedLanguage == 'tr'}">
            for (var s = 0; s < sourceDataHeat.length; s++) {
                var dayObject = new Date();
                if (sourceDataHeat[s].value1 !== 6)
                    combinedgraph[count + 2] = {"month": monthNamesTr[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": sourceDataHeat[s].value1, "color": getRiskColor(sourceDataHeat[s].value1)};
                else
                    combinedgraph[count + 2] = {"month": monthNamesTr[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": null, "color": "#ffffff"};
                dayObject.setMonth(dayObject.getMonth() - 1);
                if (sourceDataHeat[s].value2 !== 6)
                    combinedgraph[count + 1] = {"month": monthNamesTr[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": sourceDataHeat[s].value2, "color": getRiskColor(sourceDataHeat[s].value2)};
                else
                    combinedgraph[count + 1] = {"month": monthNamesTr[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": null, "color": "#ffffff"};
                dayObject.setMonth(dayObject.getMonth() - 1);
                if (sourceDataHeat[s].value3 !== 6)
                    combinedgraph[count] = {"month": monthNamesTr[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": sourceDataHeat[s].value3, "color": getRiskColor(sourceDataHeat[s].value3)};
                else
                    combinedgraph[count] = {"month": monthNamesTr[dayObject.getMonth()], "day": sourceDataHeat[s].date, "value": null, "color": "#ffffff"};
                count = count + 3;
            }
        </c:when>
    </c:choose>
            heatMap.data = combinedgraph;
            $('#heatMap').css("width:", "100%");
            $('#heatMap').css("height", "200px");
            $('#heatMapWait').hide();
            $('#heatMap').show();           
            });
        }

        //-----------------------------------------------------     RİSK SKORU TABI     -----------------------------------------------------//

        function dailyRiskScoreCharts() {
            $('#riskScoreWait').show();
            $('#riskScoreGraph').hide();

            $('#riskScoreByLevelWait').show();
            $('#riskScoreGraphByLevel').hide();

            $("#riskScoreGraph").html();
            if (riskScoreGraph !== undefined)
                riskScoreGraph.dispose();
            // Create chart instance
            riskScoreGraph = am4core.create("riskScoreGraph", am4charts.XYChart);
        <c:choose>
            <c:when test="${selectedLanguage == 'en'}">
            </c:when>
            <c:when test="${selectedLanguage == 'tr'}">
            riskScoreGraph.language.locale = am4lang_tr_TR;
            </c:when>
        </c:choose>
            riskScoreGraph.paddingRight = 20;

            // Create axes
            var dateAxis = riskScoreGraph.xAxes.push(new am4charts.DateAxis());
            dateAxis.renderer.minGridDistance = 50;
            dateAxis.renderer.grid.template.location = 0;
            dateAxis.startLocation = 0.5;
            dateAxis.endLocation = 0.5;
            dateAxis.renderer.minLabelPosition = 0.05;
            dateAxis.renderer.maxLabelPosition = 0.95;

            // Create value axis
            var valueAxis = riskScoreGraph.yAxes.push(new am4charts.ValueAxis());
            valueAxis.renderer.inside = true;
            valueAxis.renderer.maxLabelPosition = 0.99;
            valueAxis.renderer.labels.template.dy = -20;

            // Create series
            var lineSeries = riskScoreGraph.series.push(new am4charts.LineSeries());
            lineSeries.dataFields.valueY = "riskPoint";
            lineSeries.dataFields.dateX = "day";
            lineSeries.tooltipText = "{value}";
            lineSeries.strokeWidth = 3;
            lineSeries.tooltip.background.cornerRadius = 20;
            lineSeries.tooltip.background.strokeOpacity = 0;
            lineSeries.tooltip.pointerOrientation = "vertical";
            lineSeries.tooltip.label.minWidth = 40;
            lineSeries.tooltip.label.minHeight = 40;
            lineSeries.tooltip.label.textAlign = "middle";
            lineSeries.tooltip.label.textValign = "middle";

            var bullet = lineSeries.bullets.push(new am4charts.CircleBullet());
            bullet.circle.strokeWidth = 2;
            bullet.circle.radius = 4;
            bullet.circle.fill = am4core.color("#fff");
            var bullethover = bullet.states.create("hover");
            bullethover.properties.scale = 1.3;
            // Make a panning cursor
            riskScoreGraph.cursor = new am4charts.XYCursor();
            riskScoreGraph.cursor.behavior = "panXY";
            riskScoreGraph.cursor.xAxis = dateAxis;
            riskScoreGraph.cursor.snapToSeries = lineSeries;
            riskScoreGraph.scrollbarX = new am4core.Scrollbar();
            riskScoreGraph.scrollbarX.parent = riskScoreGraph.topAxesContainer;
            riskScoreGraph.scrollbarX.marginTop = 0;
            riskScoreGraph.scrollbarX.toBack();
            riskScoreGraph.events.on("ready", function () {
                dateAxis.zoom({
                    start: 0.0,
                    end: 1
                });
            });
            $("#riskScoreGraphByLevel").html();
            if (riskScoreGraphByLevel !== undefined)
                riskScoreGraphByLevel.dispose();
            /* Risk Skoru:  SEVİYEYE GÖRE GÜNLÜK RİSK SKORU GRAFİĞİ*/
            riskScoreGraphByLevel = am4core.create("riskScoreGraphByLevel", am4charts.XYChart);

            // Create axes
            var categoryAxis = riskScoreGraphByLevel.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "totalday";
            categoryAxis.renderer.opposite = "true";
            categoryAxis.renderer.minGridDistance = "50";
            categoryAxis.renderer.labels.template.rotation = "270";

            riskScoreGraphByLevel.scrollbarX = new am4core.Scrollbar();
            riskScoreGraphByLevel.scrollbarX.parent = riskScoreGraphByLevel.bottomAxesContainer;

            var valueAxis = riskScoreGraphByLevel.yAxes.push(new am4charts.ValueAxis());
            valueAxis.renderer.inside = false;
            valueAxis.renderer.labels.template.disabled = false;
            valueAxis.min = 0;
            riskScoreGraphByLevel.cursor = new am4charts.XYCursor();
            riskScoreGraphByLevel.cursor.xAxis = valueAxis;
            riskScoreGraphByLevel.cursor.lineX.disabled = true;

            // Create series
            function createriskScoreGraphByLevelSeries(field, name) {
                // Set up series
                var series = riskScoreGraphByLevel.series.push(new am4charts.LineSeries());
                series.dataFields.categoryX = "totalday";
                series.name = name;
                series.dataFields.valueY = field;
                series.tooltipText = "[bold]{name}[/]:[font-size:14px]{valueY}";
                series.fillOpacity = 0.8;
                series.strokeWidth = 2;
                series.stacked = true;
                if (field === 'totalvalue1') {
                    series.stroke = am4core.color("#F9FABB");
                    series.fill = am4core.color("#F9FABB");
                } else if (field === 'totalvalue2') {
                    series.stroke = am4core.color("#FEFE60");
                    series.fill = am4core.color("#FEFE60");
                } else if (field === 'totalvalue3') {
                    series.stroke = am4core.color("#F8C508");
                    series.fill = am4core.color("#F8C508");
                } else if (field === 'totalvalue4') {
                    series.stroke = am4core.color("#F88008");
                    series.fill = am4core.color("#F88008");
                } else if (field === 'totalvalue5') {
                    series.stroke = am4core.color("#D91E18");
                    series.fill = am4core.color("#D91E18");
                }
                return series;
            }
            createriskScoreGraphByLevelSeries("totalvalue1", "<spring:message code="dashboard.level1"/>");
            createriskScoreGraphByLevelSeries("totalvalue2", "<spring:message code="dashboard.level2"/>");
            createriskScoreGraphByLevelSeries("totalvalue3", "<spring:message code="dashboard.level3"/>");
            createriskScoreGraphByLevelSeries("totalvalue4", "<spring:message code="dashboard.level4"/>");
            createriskScoreGraphByLevelSeries("totalvalue5", "<spring:message code="dashboard.level5"/>");
            riskScoreGraphByLevel.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
        <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER_READONLY')">
            if (dailyRiskScoreData !== undefined) {
                var combinedtimegraph = [];
                for (var s = 0; s < dailyRiskScoreData.length; s++) {
                    combinedtimegraph[s] = {"totalday": dailyRiskScoreData[s].date, "totalvalue1": dailyRiskScoreData[s].level1riskPoint, "totalvalue2": dailyRiskScoreData[s].level2riskPoint,
                        "totalvalue3": dailyRiskScoreData[s].level3riskPoint, "totalvalue4": dailyRiskScoreData[s].level4riskPoint, "totalvalue5": dailyRiskScoreData[s].level5riskPoint,
                        "color5": "#D91E18",
                        "color4": "#F88008",
                        "color3": "#F8C508",
                        "color2": "#FEFE60",
                        "color1": "#F9FABB"};
                }
                riskScoreGraphByLevel.data = combinedtimegraph;
                //riskScoreGraphByLevel.validateData();
                $('#riskScoreGraphByLevel').css("width:", "100%");
                $('#riskScoreGraphByLevel').css("height", "500px");
                $('#riskScoreByLevelWait').hide();
                $('#riskScoreGraphByLevel').show();


                var combinedtimegraph2 = [];
                for (var s = 0; s < dailyRiskScoreData.length; s++) {
                    combinedtimegraph2[s] = {"day": dailyRiskScoreData[s].date, "riskPoint": dailyRiskScoreData[s].totalriskPoint};
                }
                riskScoreGraph.data = combinedtimegraph2;
                $('#riskScoreGraph').css("width:", "100%");
                $('#riskScoreGraph').css("height", "500px");
                $('#riskScoreWait').hide();
                $('#riskScoreGraph').show();
            }
        </sec:authorize>
        <sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY')">
            var obj = getObjectByForm("searchForm");
            var temp;
            $.post("riskScoreByLevel.json", obj).done(function (result) {
                temp = result;
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            }).always(function () {
                var combinedtimegraph = [];
                var temp2 = temp;
                for (var s = 0; s < temp.length; s++) {
                    combinedtimegraph[s] = {"totalday": temp[s].date, "totalvalue1": temp[s].level1count, "totalvalue2": temp[s].level2count,
                        "totalvalue3": temp[s].level3count, "totalvalue4": temp[s].level4count, "totalvalue5": temp[s].level5count,
                        "color5": "#D91E18",
                        "color4": "#F88008",
                        "color3": "#F8C508",
                        "color2": "#FEFE60",
                        "color1": "#F9FABB"};
                }
                riskScoreGraphByLevel.data = combinedtimegraph;
                //riskScoreGraphByLevel.validateData();
                $('#riskScoreGraphByLevel').css("width:", "100%");
                $('#riskScoreGraphByLevel').css("height", "500px");
                $('#riskScoreByLevelWait').hide();
                $('#riskScoreGraphByLevel').show();


                var combinedtimegraph2 = [];
                for (var s = 0; s < temp2.length; s++) {
                    combinedtimegraph2[s] = {"day": temp2[s].date, "riskPoint": temp2[s].total};
                }
                riskScoreGraph.data = combinedtimegraph2;
                $('#riskScoreGraph').css("width:", "100%");
                $('#riskScoreGraph').css("height", "500px");
                $('#riskScoreWait').hide();
                $('#riskScoreGraph').show();
            });
            </sec:authorize>
        </sec:authorize>
        }

        //-----------------------------------------------------     ZAFİYETLER TABI     -----------------------------------------------------//

        function levelcount() {        /////   RİSK SEVİYESİNE GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ   /////
            $("#riskLevelVulnGraph").html();
            if (riskLevelVulnGraph !== undefined)
                riskLevelVulnGraph.dispose();
            /* Zafiyet Tabı: RİSK SEVİYESİNE GÖRE VARLIKLARIN DAĞILIMI*/
            riskLevelVulnGraph = am4core.create("riskLevelVulnGraph", am4charts.PieChart3D);
            riskLevelVulnGraph.hiddenState.properties.opacity = 0; // this creates initial fade-in
            riskLevelVulnGraph.depth = 40;
            riskLevelVulnGraph.innerRadius = am4core.percent(40);
            riskLevelVulnGraph.data = [];
            var series = riskLevelVulnGraph.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "value";
            series.dataFields.category = "name";
            series.dataFields.depthValue = "value";
            series.colors.list = [
                new am4core.color('#F9FABB'),
                new am4core.color('#FEFE60'),
                new am4core.color('#F8C508'),
                new am4core.color('#F88008'),
                new am4core.color('#D91E18')
            ];
            series.slices.template.cornerRadius = 5;
            series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.ticks.template.adapter.add("hidden", hideSmall);
            series.labels.template.adapter.add("hidden", hideSmall);
            function hideSmall(hidden, target) {
                return target.dataItem.values.value.percent <= 0 ? true : false;
            }
            series.slices.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?level=' + ev.target.dataItem.dataContext.riskLevel;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            },
                    this
                    );

            riskLevelVulnIndicator = riskLevelVulnGraph.tooltipContainer.createChild(am4core.Container);
            riskLevelVulnIndicator.background.fill = am4core.color("#fff");
            riskLevelVulnIndicator.background.fillOpacity = 0.8;
            riskLevelVulnIndicator.width = am4core.percent(100);
            riskLevelVulnIndicator.height = am4core.percent(100);

            var riskLevelVulnIndicatorLabel = riskLevelVulnIndicator.createChild(am4core.Label);
            riskLevelVulnIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            riskLevelVulnIndicatorLabel.align = "center";
            riskLevelVulnIndicatorLabel.valign = "middle";
            riskLevelVulnIndicatorLabel.fontSize = 12;
        <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER_READONLY')">
            if (vulnLevelCountData !== undefined) {
                var level5 = vulnLevelCountData[vulnLevelCountData.length - 1].level5count;
                var level4 = vulnLevelCountData[vulnLevelCountData.length - 1].level4count;
                var level3 = vulnLevelCountData[vulnLevelCountData.length - 1].level3count;
                var level2 = vulnLevelCountData[vulnLevelCountData.length - 1].level2count;
                var level1 = vulnLevelCountData[vulnLevelCountData.length - 1].level1count;
                if (0 === level1 && 0 === level2 && 0 === level3 && 0 === level4 && 0 === level5) {
                    var emptyData = [];
                    emptyData[0] = {"name": "-", "value": 0, "riskLevel": 1, "color": '#F9FABB'};
                    /*  $('#riskLevelVulnGraph').removeAttr('style');
                     $('#riskLevelVulnGraph').css("text-align", "center");
                     $('#riskLevelVulnGraph').css("width:", "100%");
                     $('#riskLevelVulnGraph').css("height", "400px");
                     $('#riskLevelVulnGraph').css("line-height", "400px");
                     $('#riskLevelVulnGraph').text("<spring:message code="generic.emptyGraph"/>"); */
                    riskLevelVulnGraph.data = emptyData;
                    riskLevelVulnIndicator.show();
                } else {
                    $('#riskLevelVulnGraph').css("line-height", "");
                    var dataSub = [{
                            "name": decodeHtml("<spring:message code="dashboard.level1"/>"),
                            "value": 0, "riskLevel": 1, "color": '#F9FABB'
                        }, {
                            "name": decodeHtml("<spring:message code="dashboard.level2"/>"),
                            "value": 0, "riskLevel": 2, "color": '#FEFE60'
                        }, {
                            "name": decodeHtml("<spring:message code="dashboard.level3"/>"),
                            "value": 0, "riskLevel": 3, "color": '#F8C508'
                        }, {
                            "name": decodeHtml("<spring:message code="dashboard.level4"/>"),
                            "value": 0, "riskLevel": 4, "color": '#F88008'
                        }, {
                            "name": decodeHtml("<spring:message code="dashboard.level5"/>"),
                            "value": 0, "riskLevel": 5, "color": '#D91E18'
                        }];
                    dataSub[0].value = level1;
                    dataSub[1].value = level2;
                    dataSub[2].value = level3;
                    dataSub[3].value = level4;
                    dataSub[4].value = level5;
                    riskLevelVulnGraph.data = dataSub;
                    //riskLevelVulnGraph.validateNow();
                    riskLevelVulnIndicator.hide();
                }
                $("#vulnerabilitiesByRiskLevelsWait").hide();
                $("#riskLevelVulnGraph").show();
            }
        </sec:authorize>
        <sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
            <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY')">            
            var temp;
            var obj = getObjectByForm("searchForm");
            $.post("vulnlevel.json", obj).done(function (result) {
                temp = result;
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            }).always(function () {
                if (0 === temp[0] && 0 === temp[1] && 0 === temp[2] && 0 === temp[3] && 0 === temp[4]) {
                    var emptyData = [];
                    emptyData[0] = {"name": "-", "value": 0, "riskLevel": 1, "color": '#F9FABB'};
                    riskLevelVulnGraph.data = emptyData;
                    riskLevelVulnIndicator.show();
                } else {
                    $('#riskLevelVulnGraph').css("line-height", "");
                    var dataSub = [{
                            "name": decodeHtml("<spring:message code="dashboard.level1"/>"),
                            "value": 0, "riskLevel": 1, "color": '#F9FABB'
                        }, {
                            "name": decodeHtml("<spring:message code="dashboard.level2"/>"),
                            "value": 0, "riskLevel": 2, "color": '#FEFE60'
                        }, {
                            "name": decodeHtml("<spring:message code="dashboard.level3"/>"),
                            "value": 0, "riskLevel": 3, "color": '#F8C508'
                        }, {
                            "name": decodeHtml("<spring:message code="dashboard.level4"/>"),
                            "value": 0, "riskLevel": 4, "color": '#F88008'
                        }, {
                            "name": decodeHtml("<spring:message code="dashboard.level5"/>"),
                            "value": 0, "riskLevel": 5, "color": '#D91E18'
                        }];
                    dataSub[0].value = temp[0];
                    dataSub[1].value = temp[1];
                    dataSub[2].value = temp[2];
                    dataSub[3].value = temp[3];
                    dataSub[4].value = temp[4];
                    riskLevelVulnGraph.data = dataSub;
                    riskLevelVulnIndicator.hide();
                }
               
                $("#vulnerabilitiesByRiskLevelsWait").hide();
                $("#riskLevelVulnGraph").show();

            });
            </sec:authorize>
        </sec:authorize>            
        }
        function vulneffect() {              /////   ETKİYE GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#effectgraph").html();
            if (effectgraph !== undefined)
                effectgraph.dispose();
            /* Zafiyet Tabı: ETKİYE GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ */
            effectgraph = am4core.create("effectgraph", am4charts.XYChart3D);
            // Create axes
            var categoryAxis = effectgraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";
            categoryAxis.renderer.labels.template.rotation = 315;
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 20;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.disabled = true;
            categoryAxis.renderer.inversed = true;

            var label = categoryAxis.renderer.labels.template;
            label.wrap = true;
            label.maxWidth = 120;
            effectgraph.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            var valueAxis = effectgraph.yAxes.push(new am4charts.ValueAxis());

            // Create series
            var series = effectgraph.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueY = "value";
            series.dataFields.categoryX = "name";
            series.name = "value";
            series.tooltipText = "{categoryX}: [bold]{valueY}[/]";
            series.columns.template.fillOpacity = .8;
            series.columns.template.width = am4core.percent(40);
            series.columns.template.height = am4core.percent(40);

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            columnTemplate.adapter.add("fill", function (fill, target) {
                return effectgraph.colors.getIndex(target.dataItem.index);
            });

            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return effectgraph.colors.getIndex(target.dataItem.index);
            });

            effectgraph.cursor = new am4charts.XYCursor();
            effectgraph.cursor.lineX.strokeOpacity = 0;
            effectgraph.cursor.lineY.strokeOpacity = 0;
            effectgraph.events.on("beforedatavalidated", function (ev) {
                effectgraph.data.sort(function (a, b) {
                    return (a.value) - (b.value);
                });
            });
            series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.columns.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?effectValue=' + ev.target.dataItem.dataContext.type;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            },
                    this
                    );


            effectIndicator = effectgraph.tooltipContainer.createChild(am4core.Container);
            effectIndicator.background.fill = am4core.color("#fff");
            effectIndicator.background.fillOpacity = 0.8;
            effectIndicator.width = am4core.percent(100);
            effectIndicator.height = am4core.percent(100);

            var effectIndicatorLabel = effectIndicator.createChild(am4core.Label);
            effectIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            effectIndicatorLabel.align = "center";
            effectIndicatorLabel.valign = "middle";
            effectIndicatorLabel.fontSize = 12;
                $.post("vulneffect.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    var combined = [];
                    var i = 0;
                    for (i = 0; i < temp.length; i++) {
                        if (temp[i] !== 0) {
                            combined.push({"name": decodeHtml(temp[i].value), "type": temp[i].name, "value": temp[i].count});
                        }
                    }
                    if (0 === combined.length) {
                        var emptyData = [];
                        emptyData[0] = {"name": "-", "type": "-", "value": 0};
                        /*   $('#effectgraph').removeAttr('style');
                         $('#effectgraph').css("text-align", "center");
                         $('#effectgraph').css("width:", "100%");
                         $('#effectgraph').css("height", "400px");
                         $('#effectgraph').css("line-height", "400px");
                         $('#effectgraph').text("<spring:message code="generic.emptyGraph"/>"); */
                        effectgraph.data = emptyData;
                        effectIndicator.show();
                    } else {
                        $('#effectgraph').css("line-height", "");
                        effectgraph.data = combined;
                        /*effectgraph.validateData();
                         effectgraph.animateAgain();
                         effectgraph.invalidateSize();*/
                        effectIndicator.hide();
                    }        
                        $("#weaknessByImpactWait").hide();
                        $("#effectgraph").show();
            });
        }
        function cveDistribution() {              /////   ZAFİYETLERİN CVE DAĞILIMINI YILLARA GÖRE GÖSTEREN GRAFİK   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#cvegraph").html();
            if (cvegraph !== undefined)
                cvegraph.dispose();
            /* Zafiyet Tabı: ZAFİYETLERİN CVE DAĞILIMINI YILLARA GÖRE GÖSTEREN GRAFİK */
            cvegraph = am4core.create("cvegraph", am4charts.XYChart3D);
            // Create axes
            var categoryAxis = cvegraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "id";
            categoryAxis.renderer.labels.template.rotation = 315;
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 20;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.disabled = true;
            categoryAxis.renderer.inversed = true;

            var label = categoryAxis.renderer.labels.template;
            label.wrap = true;
            label.maxWidth = 120;
            cvegraph.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            var valueAxis = cvegraph.yAxes.push(new am4charts.ValueAxis());

            // Create series
            var series = cvegraph.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueY = "count";
            series.dataFields.categoryX = "id";
            series.name = "value";
            series.tooltipText = "{categoryX}: [bold]{valueY}[/]";
            series.columns.template.fillOpacity = .8;
            series.columns.template.width = am4core.percent(40);
            series.columns.template.height = am4core.percent(40);

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            columnTemplate.adapter.add("fill", function (fill, target) {
                return cvegraph.colors.getIndex(target.dataItem.index);
            });

            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return cvegraph.colors.getIndex(target.dataItem.index);
            });

            cvegraph.cursor = new am4charts.XYCursor();
            cvegraph.cursor.lineX.strokeOpacity = 0;
            cvegraph.cursor.lineY.strokeOpacity = 0;
            cvegraph.events.on("beforedatavalidated", function (ev) {
                cvegraph.data.sort(function (a, b) {
                    return (a.value) - (b.value);
                });
            });
            series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.columns.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?cveValue=' + ev.target.dataItem.dataContext.type;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            },
                    this
                    );


            cveIndicator = cvegraph.tooltipContainer.createChild(am4core.Container);
            cveIndicator.background.fill = am4core.color("#fff");
            cveIndicator.background.fillOpacity = 0.8;
            cveIndicator.width = am4core.percent(100);
            cveIndicator.height = am4core.percent(100);

            var cveIndicatorLabel = cveIndicator.createChild(am4core.Label);
            cveIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            cveIndicatorLabel.align = "center";
            cveIndicatorLabel.valign = "middle";
            cveIndicatorLabel.fontSize = 12;
                $.post("cveDistribution.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
                    var combined = [];
                    var i = 0;
                    var j = 0;
                    for (i = 0; i < temp.length; i++) {
                        temp[i].id = temp[i].id.split("-")[1];
                    }
                    for (i = 0; i < temp.length; i++) {
                        for(j = temp.length - 1 ;j > i;j--) {
                            if(parseInt(temp[j-1].id)<parseInt(temp[j].id)){
                                var tempCount = temp[j-1].count;
                                var tempYear = temp[j-1].id;
                                temp[j-1].id = temp[j].id;
                                temp[j-1].count = temp[j].count;
                                temp[j].id = tempYear;
                                temp[j].count = tempCount;
                            }
                        }
                    }
                    for (i = 0; i < temp.length; i++) {
                        for(j = i+1; j < temp.length; j++) {
                            if(parseInt(temp[i].id) == parseInt(temp[j].id)){
                                temp[i].count=parseInt(temp[i].count)+parseInt(temp[j].count)
                            }
                        }
                    }
                    for (i = 0; i < temp.length; i++) {
                        if(parseInt(temp[i].id)>=2015){
                            if (temp[i] !== 0) {
                                combined.push({"id": decodeHtml(temp[i].id), "type": temp[i].id, "count": temp[i].count});
                            }
                        }
                    }
                    if (0 === combined.length) {
                        var emptyData = [];
                        emptyData[0] = {"name": "-", "type": "-", "value": 0};
                        /*   $('#cvegraph').removeAttr('style');
                         $('#cvegraph').css("text-align", "center");
                         $('#cvegraph').css("width:", "100%");
                         $('#cvegraph').css("height", "400px");
                         $('#cvegraph').css("line-height", "400px");
                         $('#cvegraph').text("<spring:message code="generic.emptyGraph"/>"); */
                        cvegraph.data = emptyData;
                        cveIndicator.show();
                    } else {
                        $('#cvegraph').css("line-height", "");
                        cvegraph.data = combined;
                        /*cvegraph.validateData();
                         cvegraph.animateAgain();
                         cvegraph.invalidateSize();*/
                        cveIndicator.hide();
                    }        
                        $("#cveDisributionWait").hide();
                        $("#cvegraph").show();
            });
        }
        function top10kb() {               /////   EN ÇOK KARŞILAŞILAN 10 ZAFİYET GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            obj["limit"] = 10;
            $("#top10kbgraph").html();
            if (top10kbgraph !== undefined)
                top10kbgraph.dispose();
            /* Zafiyet Tabı: EN ÇOK KARŞILAŞILAN 10 ZAFİYET */
            top10kbgraph = am4core.create("top10kbgraph", am4charts.XYChart3D);
            // Create axes
            var categoryAxis = top10kbgraph.yAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 30;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.label.horizontalCenter = "right";
            categoryAxis.tooltip.label.verticalCenter = "middle";
            categoryAxis.cursorTooltipEnabled = false;

            var label = categoryAxis.renderer.labels.template;
            label.truncate = true;
            label.maxWidth = 250;
            top10kbgraph.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            var valueAxis = top10kbgraph.xAxes.push(new am4charts.ValueAxis());
            valueAxis.cursorTooltipEnabled = false;

            // Create series
            var series = top10kbgraph.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueX = "value";
            series.dataFields.categoryY = "name";
            series.name = "value";
            series.tooltipText = "{categoryY}: [bold]{valueX}[/]";
            series.columns.template.fillOpacity = .8;
            series.columns.template.width = am4core.percent(40);
            series.columns.template.height = am4core.percent(40);

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            columnTemplate.adapter.add("fill", function (fill, target) {
                return top10kbgraph.colors.getIndex(target.dataItem.index);
            });

            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return top10kbgraph.colors.getIndex(target.dataItem.index);
            });

            top10kbgraph.cursor = new am4charts.XYCursor();
            top10kbgraph.cursor.lineX.strokeOpacity = 0;
            top10kbgraph.cursor.lineY.strokeOpacity = 0;
            top10kbgraph.events.on("beforedatavalidated", function (ev) {
                top10kbgraph.data.sort(function (a, b) {
                    return (a.value) - (b.value);
                });
            });
            series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.columns.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?vulnerabilityName=' + ev.target.dataItem.dataContext.name;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            },
                    this
                    );
            top10kbIndicator = top10kbgraph.tooltipContainer.createChild(am4core.Container);
            top10kbIndicator.background.fill = am4core.color("#fff");
            top10kbIndicator.background.fillOpacity = 0.8;
            top10kbIndicator.width = am4core.percent(100);
            top10kbIndicator.height = am4core.percent(100);

            var top10kbIndicatorLabel = top10kbIndicator.createChild(am4core.Label);
            top10kbIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            top10kbIndicatorLabel.align = "center";
            top10kbIndicatorLabel.valign = "middle";
            top10kbIndicatorLabel.fontSize = 12;
                $.post("top10kb.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var combined = [];
            for (var i = 0; i < temp.length; i++) {
                combined[i] = {"name": decodeHtml(temp[i].name), "value": temp[i].count};
            }
            if (0 === combined.length) {
                var emptyData = [];
                emptyData[0] = {"name": "-", "value": 0};
                /*$('#top10kbgraph').removeAttr('style');
                 $('#top10kbgraph').css("text-align", "center");
                 $('#top10kbgraph').css("width:", "100%");
                 $('#top10kbgraph').css("height", "400px");
                 $('#top10kbgraph').css("line-height", "400px");
                 $('#top10kbgraph').text("<spring:message code="generic.emptyGraph"/>"); */
                top10kbgraph.data = emptyData;
                top10kbIndicator.show();
            } else {
                $('#top10kbgraph').css("line-height", "");
                top10kbgraph.data = combined;
                top10kbIndicator.hide();
            }
                
                $("#top10VulnerabilitiesWait").hide();
                $("#top10kbgraph").show();
                
            });
        }
        function rootcause() {                       /////   KÖK NEDENİNE GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#rootcausegraph").html();
            if (rootcausegraph !== undefined)
                rootcausegraph.dispose();
            /* Zafiyet Tabı:  KÖK NEDENİNE GÖRE ZAFİYETLERİN DAĞILIMI */
            rootcausegraph = am4core.create("rootcausegraph", am4charts.RadarChart);
            rootcausegraph.data = [];

            /* Create axes */
            var categoryAxis = rootcausegraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";

            var valueAxis = rootcausegraph.yAxes.push(new am4charts.ValueAxis());
            valueAxis.extraMin = 0.2;
            valueAxis.extraMax = 0.2;

            valueAxis.tooltip.disabled = true;

            /* Create and configure series */
            var series1 = rootcausegraph.series.push(new am4charts.RadarSeries());
            series1.dataFields.valueY = "value";
            series1.dataFields.categoryX = "name";
            series1.strokeWidth = 3;
            series1.tooltipText = "{valueY}";
            var bullet = series1.bullets.create(am4charts.CircleBullet);
            series1.maxWidth = 100;
            rootcausegraph.interactionsEnabled = true;
            bullet.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?rootCauseValue=' + ev.target.dataItem.dataContext.type;
                url = addFilterToUrl(url);
                window.open(url,'_blank');
            });
            rootcausegraph.cursor = new am4charts.RadarCursor();
            rootcauseIndicator = rootcausegraph.tooltipContainer.createChild(am4core.Container);
            rootcauseIndicator.background.fill = am4core.color("#fff");
            rootcauseIndicator.background.fillOpacity = 0.8;
            rootcauseIndicator.width = am4core.percent(100);
            rootcauseIndicator.height = am4core.percent(100);

            var rootcauseIndicatorLabel = rootcauseIndicator.createChild(am4core.Label);
            rootcauseIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            rootcauseIndicatorLabel.align = "center";
            rootcauseIndicatorLabel.valign = "middle";
            rootcauseIndicatorLabel.fontSize = 12;

                $.post("rootcause.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var combined = [];
            for (var i = 0; i < temp.length; i++) {
                combined[i] = {"name": decodeHtml(temp[i].value), "type": temp[i].name, "value": temp[i].count};
            }
            if (0 === combined.length) {
                var emptyData = [];
                emptyData[0] = {"name": "-", "type": "-", "value": 0};
                /* $('#rootcausegraph').removeAttr('style');
                 $('#rootcausegraph').css("text-align", "center");
                 $('#rootcausegraph').css("width:", "100%");
                 $('#rootcausegraph').css("height", "400px");
                 $('#rootcausegraph').css("line-height", "400px");
                 $('#rootcausegraph').text("<spring:message code="generic.emptyGraph"/>"); */
                rootcausegraph.data = emptyData;
                rootcauseIndicator.show();

            } else {
                $('#rootcausegraph').css("line-height", "");
                rootcausegraph.data = combined;
                rootcauseIndicator.hide();

            }
                
                $("#rootCauseGraphWait").hide();
                $("#rootcausegraph").show();
                
            });
        }

        //-----------------------------------------------------     PORTLAR TABI     -----------------------------------------------------//

        function ports() {       /////   PORTLARA GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#portgraph").html();
            if (portgraph !== undefined)
                portgraph.dispose();
            /* Port Tabı:  PORTLARA GÖRE ZAFİYETLERİN DAĞILIMI*/
            portgraph = am4core.create("portgraph", am4charts.XYChart3D);
            // Create axes
            var categoryAxis = portgraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "ports";
            categoryAxis.renderer.grid.template.location = 0;
            categoryAxis.renderer.minGridDistance = 30;
            categoryAxis.numberFormatter.numberFormat = "#.##";
            var valueAxis = portgraph.yAxes.push(new am4charts.ValueAxis());
            valueAxis.calculateTotals = true;
            // Create series
            function createPortGraphSeries(field, name) {

                // Set up series
                var series = portgraph.series.push(new am4charts.ColumnSeries3D());
                series.name = name;
                series.dataFields.valueY = field;
                series.dataFields.categoryX = "ports";
                series.sequencedInterpolation = true;

                series.stroke = am4core.color("#ffffff");
                if (field === 'portlevel1')
                    series.columns.template.fill = am4core.color("#F9FABB");
                else if (field === 'portlevel2')
                    series.columns.template.fill = am4core.color("#FEFE60");
                else if (field === 'portlevel3')
                    series.columns.template.fill = am4core.color("#F8C508");
                else if (field === 'portlevel4')
                    series.columns.template.fill = am4core.color("#F88008");
                else if (field === 'portlevel5')
                    series.columns.template.fill = am4core.color("#D91E18");
                // Make it stacked
                series.stacked = true;

                // Configure columns
                series.columns.template.fillOpacity = .8;
                series.columns.template.width = am4core.percent(60);
                series.columns.template.tooltipText = "[bold]{categoryX}[/]\n[font-size:14px]" + series.name + ": {valueY}";

                // Add label
                var labelBullet = series.bullets.push(new am4charts.LabelBullet());
                if (field === "portlevel5") {
                    labelBullet.label.text = "[font-size: 15px]{valueY.total}[/]";
                    labelBullet.label.dy = -15;
                    labelBullet.label.verticalCenter = "bottom";
                    portgraph.maskBullets = false;
                    labelBullet.label.adapter.add("hidden", hideSmall);
                }

                series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                series.columns.template.events.on("hit", function (ev) {
                    var url = '../customer/listVulnerabilities.htm?portValue=' + ev.target.dataItem.dataContext.ports;
                    switch (ev.target.dom.attributes['fill'].nodeValue) {
                        case ev.target.dataItem.dataContext.portcolor1:
                            url += '&level=1';
                            break;
                        case ev.target.dataItem.dataContext.portcolor2:
                            url += '&level=2';
                            break;
                        case ev.target.dataItem.dataContext.portcolor3:
                            url += '&level=3';
                            break;
                        case ev.target.dataItem.dataContext.portcolor4:
                            url += '&level=4';
                            break;
                        case ev.target.dataItem.dataContext.portcolor5:
                            url += '&level=5';
                            break;
                        default:
                            break;
                    }
                    url = addFilterToUrl(url);
                    window.open(url, '_blank');
                },
                        this
                        );
                return series;
            }
            function hideSmall(hidden, target) {
                if (target.dataItem.values.valueY.total === 0) {
                    return true;
                }
                return false;
            }
            createPortGraphSeries("portlevel1", "<spring:message code="dashboard.level1"/>");
            createPortGraphSeries("portlevel2", "<spring:message code="dashboard.level2"/>");
            createPortGraphSeries("portlevel3", "<spring:message code="dashboard.level3"/>");
            createPortGraphSeries("portlevel4", "<spring:message code="dashboard.level4"/>");
            createPortGraphSeries("portlevel5", "<spring:message code="dashboard.level5"/>");


            portIndicator = portgraph.tooltipContainer.createChild(am4core.Container);
            portIndicator.background.fill = am4core.color("#fff");
            portIndicator.background.fillOpacity = 0.8;
            portIndicator.width = am4core.percent(100);
            portIndicator.height = am4core.percent(100);

            var portIndicatorLabel = portIndicator.createChild(am4core.Label);
            portIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            portIndicatorLabel.align = "center";
            portIndicatorLabel.valign = "middle";
            portIndicatorLabel.fontSize = 12;
                $.post("ports.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var counts5 = [];
            var counts4 = [];
            var counts3 = [];
            var counts2 = [];
            var counts1 = [];
            var combinedports = [];
            for (var i = 0; i < temp.length; i++) {
                counts5[i] = temp[i].level5;
                counts4[i] = temp[i].level4;
                counts3[i] = temp[i].level3;
                counts2[i] = temp[i].level2;
                counts1[i] = temp[i].level1;
            }
            for (var s = 0; s < temp.length; s++) {
                combinedports[s] = {"ports": temp[s].portNumber, "portlevel1": counts1[s], "portlevel2": counts2[s],
                    "portlevel3": counts3[s], "portlevel4": counts4[s], "portlevel5": counts5[s],
                    "portcolor5": "#d91e18",
                    "portcolor4": "#f88008",
                    "portcolor3": "#f8c508",
                    "portcolor2": "#fefe60",
                    "portcolor1": "fF9fabb"};
            }
            if (0 === combinedports.length) {
                /* $('#portgraph').removeAttr('style');
                 $('#portgraph').css("text-align", "center");
                 $('#portgraph').css("width:", "100%");
                 $('#portgraph').css("height", "400px");
                 $('#portgraph').css("line-height", "400px");
                 $('#portgraph').text("<spring:message code="generic.emptyGraph"/>");*/
                portgraph.data = [];
                portIndicator.show();
            } else {
                $('#portgraph').css("line-height", "");
                portgraph.data = combinedports;
                portIndicator.hide();
            }
                
                $("#accordingToPortWait").hide();
                $("#portgraph").show();
            });
        }
        function servicefunction() {     /////   TESPİT EDİLEN SERVİSLER GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#portservices").html();
            if (portservices !== undefined)
                portservices.dispose();
            /* Port Tabı:  PORTLARA GÖRE ZAFİYETLERİN DAĞILIMI*/
            portservices = am4core.create("portservices", am4charts.PieChart3D);
            portservices.hiddenState.properties.opacity = 0; // this creates initial fade-in

            var series = portservices.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "value";
            series.dataFields.category = "name";
            series.ticks.template.disabled = true;
            series.alignLabels = false;
            series.labels.template.text = "{value.percent.formatNumber('#.0')}%";
            series.labels.template.radius = am4core.percent(10);
            series.labels.template.fill = am4core.color("black");

            var label = series.labels.template;
            label.truncate = true;
            label.maxWidth = 100;
            series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.ticks.template.adapter.add("hidden", hideSmall);
            series.labels.template.adapter.add("hidden", hideSmall);
            function hideSmall(hidden, target) {
                return target.dataItem.values.value.percent <= 0 ? true : false;
            }
            series.slices.template.events.on("hit", function (ev) {
                var url = '../customer/listAssets.htm?serviceValue=' + ev.target.dataItem.dataContext.name;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            }, this);


            portservicesLegend = am4core.create("portservicesLegend", am4core.Container);
            portservicesLegend.width = am4core.percent(100);
            portservicesLegend.height = am4core.percent(100);
            portservices.legend = new am4charts.Legend();
            portservices.legend.parent = portservicesLegend;
            portservices.legend.scale = 0.6;
            portservices.legend.fontSize = 18;

            portservices.events.on("datavalidated", resizeLegend);
            portservices.events.on("maxsizechanged", resizeLegend);

            function resizeLegend(ev) {
                document.getElementById("portservicesLegend").style.height = portservices.data.length*25 + "px";
            }



            portservicesIndicator = portservices.tooltipContainer.createChild(am4core.Container);
            portservicesIndicator.background.fill = am4core.color("#fff");
            portservicesIndicator.background.fillOpacity = 0.8;
            portservicesIndicator.width = am4core.percent(100);
            portservicesIndicator.height = am4core.percent(100);

            var portservicesIndicatorLabel = portservicesIndicator.createChild(am4core.Label);
            portservicesIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            portservicesIndicatorLabel.align = "center";
            portservicesIndicatorLabel.valign = "middle";
            portservicesIndicatorLabel.fontSize = 12;
                $.post("services.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var combined = [];
            for (var i = 0; i < temp.length; i++) {
                combined[i] = {"name": decodeHtml(temp[i].name), "value": temp[i].count};
            }
            if (0 === combined.length) {
                /*$('#portservices').removeAttr('style');
                 $('#portservices').css("text-align", "center");
                 $('#portservices').css("width:", "100%");
                 $('#portservices').css("height", "400px");
                 $('#portservices').css("line-height", "400px");
                 $('#portservices').text("<spring:message code="generic.emptyGraph"/>"); */
                portservices.data = [];
                portservicesIndicator.show();
            } else {
                $('#portservices').css("line-height", "");
                portservices.data = combined;
                portservicesIndicator.hide();
            }        
                
                $("#accordingToPortServiceWait").hide();
                $("#portservices").show();
            });
        }
        function operatingsystemsfunction() {     /////   İŞLETİM SİSTEMLERİNE GÖRE VARLIK SAYILARI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#operatingsystems").html();
            if (operatingsystems !== undefined)
                operatingsystems.dispose();
            $("#legendwrapper").html();
            if (operatingSystemsLegend !== undefined)
                operatingSystemsLegend.dispose();
            /* Port Tabı:   İŞLETİM SİSTEMLERİNE GÖRE VARLIK SAYILARI */
            operatingsystems = am4core.create("operatingsystems", am4charts.PieChart3D);
            operatingsystems.hiddenState.properties.opacity = 0; // this creates initial fade-in


            var series = operatingsystems.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "value";
            series.dataFields.category = "name";
            var label = series.labels.template;
            label.truncate = true;
            label.maxWidth = 160;
            series.ticks.template.disabled = true;
            series.alignLabels = false;
            series.labels.template.text = "{value.percent.formatNumber('#.0')}%";
            series.labels.template.radius = am4core.percent(10);
            series.labels.template.fill = am4core.color("black");
            series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.ticks.template.adapter.add("hidden", hideSmall);
            series.labels.template.adapter.add("hidden", hideSmall);
            function hideSmall(hidden, target) {
                return target.dataItem.values.value.percent < 5 ? true : false;
            }
            series.slices.template.events.on("hit", function (ev) {
                var url = '../customer/listAssets.htm?osValue=' + ev.target.dataItem.dataContext.os;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            }, this);
            operatingSystemsLegend = am4core.create("operatingSystemsLegend", am4core.Container);
            operatingSystemsLegend.width = am4core.percent(100);
            operatingSystemsLegend.height = am4core.percent(100);
            operatingsystems.legend = new am4charts.Legend();
            operatingsystems.legend.parent = operatingSystemsLegend;
            operatingsystems.legend.scale = 0.6;
            operatingsystems.legend.fontSize = 18;

            operatingsystems.events.on("datavalidated", resizeLegend);
            operatingsystems.events.on("maxsizechanged", resizeLegend);

            function resizeLegend(ev) {
                document.getElementById("operatingSystemsLegend").style.height = operatingsystems.data.length*25 + "px";
            }


            //chartdiv.scale = 1.1;

            operatingsystemsIndicator = operatingsystems.tooltipContainer.createChild(am4core.Container);
            operatingsystemsIndicator.background.fill = am4core.color("#fff");
            operatingsystemsIndicator.background.fillOpacity = 0.8;
            operatingsystemsIndicator.width = am4core.percent(100);
            operatingsystemsIndicator.height = am4core.percent(100);

            var operatingsystemsIndicatorLabel = operatingsystemsIndicator.createChild(am4core.Label);
            operatingsystemsIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            operatingsystemsIndicatorLabel.align = "center";
            operatingsystemsIndicatorLabel.valign = "middle";
            operatingsystemsIndicatorLabel.fontSize = 12;

            var osOption = $("label[for='osoptions'].active")[0].firstElementChild.defaultValue;
            obj["option"] = osOption;
                $.post("operatinSystemCount.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var combined = [];
            for (var i = 0; i < temp.length; i++) {
                combined[i] = {"name": decodeHtml(temp[i].name), "os": decodeHtml(temp[i].operatingSystem), "value": temp[i].score};
            }
            if (0 === combined.length) {
                operatingsystems.data = [];
                operatingsystemsIndicator.show();

            } else {
                $('#operatingsystems').css("line-height", "");
                operatingsystems.data = combined;
                operatingsystemsIndicator.hide();
            }            
                
                $("#accordingToOperatingSystemsWait").hide();
                $("#operatingsystems").show();
            });
        }      
        function assetsbyassetgroupfunction() {     /////   VARLIK GRUPLARINA GÖRE VARLIK SAYILARI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#assetsbyassetgroup").html();
            if (assetsbyassetgroup !== undefined)
                assetsbyassetgroup.dispose();
            /* Port Tabı:   VARLIK GRUPLARINA GÖRE VARLIK SAYILARI GRAFİĞİ  */
            assetsbyassetgroup = am4core.create("assetsbyassetgroup", am4charts.PieChart3D);
            assetsbyassetgroup.hiddenState.properties.opacity = 0; // this creates initial fade-in

            var series = assetsbyassetgroup.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "value";
            series.dataFields.category = "name";
            series.ticks.template.disabled = true;
            series.alignLabels = false;
            series.labels.template.text = "{value.percent.formatNumber('#.0')}%";
            series.labels.template.radius = am4core.percent(10);
            series.labels.template.fill = am4core.color("black");
            var label = series.labels.template;
            label.truncate = true;
            label.maxWidth = 100;
            series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.ticks.template.adapter.add("hidden", hideSmall);
            series.labels.template.adapter.add("hidden", hideSmall);
            function hideSmall(hidden, target) {
                return target.dataItem.values.value.percent <= 0 ? true : false;
            }
            series.slices.template.events.on("hit", function (ev) {
                var url = '../customer/listAssets.htm?groupId=' + ev.target.dataItem.dataContext.id;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            }, this);

            assetsbyassetgroupLegend = am4core.create("assetsbyassetgroupLegend", am4core.Container);
            assetsbyassetgroupLegend.width = am4core.percent(100);
            assetsbyassetgroupLegend.height = am4core.percent(100);
            assetsbyassetgroup.legend = new am4charts.Legend();
            assetsbyassetgroup.legend.parent = assetsbyassetgroupLegend;
            assetsbyassetgroup.legend.scale = 0.6;
            assetsbyassetgroup.legend.fontSize = 18;

            assetsbyassetgroup.events.on("datavalidated", resizeLegend);
            assetsbyassetgroup.events.on("maxsizechanged", resizeLegend);

            function resizeLegend(ev) {
                document.getElementById("assetsbyassetgroupLegend").style.height = assetsbyassetgroup.data.length*25 + "px";
            }

            assetsbyassetgroupIndicator = assetsbyassetgroup.tooltipContainer.createChild(am4core.Container);
            assetsbyassetgroupIndicator.background.fill = am4core.color("#fff");
            assetsbyassetgroupIndicator.background.fillOpacity = 0.8;
            assetsbyassetgroupIndicator.width = am4core.percent(100);
            assetsbyassetgroupIndicator.height = am4core.percent(100);

            var assetsbyassetgroupIndicatorLabel = assetsbyassetgroupIndicator.createChild(am4core.Label);
            assetsbyassetgroupIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            assetsbyassetgroupIndicatorLabel.align = "center";
            assetsbyassetgroupIndicatorLabel.valign = "middle";
            assetsbyassetgroupIndicatorLabel.fontSize = 12;
            $.post("countAssetsbyAssetGroup.json", obj).done(function (result) {
                temp = result;
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            }).always(function () {
                var combined = [];
                for (var i = 0; i < temp.length; i++) {
                    combined[i] = {"name": decodeHtml(temp[i].allGroups), "id": temp[i].groupId, "value": temp[i].score};
                }
                if (0 === combined.length) {
                    assetsbyassetgroup.data = [];
                    assetsbyassetgroupIndicator.show();
                } else {
                    $('#assetsbyassetgroup').css("line-height", "");
                    assetsbyassetgroup.data = combined;
                    assetsbyassetgroupIndicator.hide();
                }             
                $("#accordingToAssetsGroupCountWait").hide();
                $("#assetsbyassetgroup").show();
            });
        }

        //-----------------------------------------------------     ZAFİYET KATEGORİLERİ TABI     -----------------------------------------------------//

        function categoryfunction() {       /////   KATEGORİLERE GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#categorygraph").html();
            if (categorygraph !== undefined)
                categorygraph.dispose();
            /* Zafiyet Kategorileri Tabı:    KATEGORİLERE GÖRE ZAFİYETLERİN DAĞILIMI */
            categorygraph = am4core.create("categorygraph", am4charts.XYChart3D);
            // Create axes
            var categoryAxis = categorygraph.yAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 5;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.label.horizontalCenter = "right";
            categoryAxis.tooltip.label.verticalCenter = "middle";
            categoryAxis.cursorTooltipEnabled = false;

            var label = categoryAxis.renderer.labels.template;
            label.truncate = true;
            label.maxWidth = 250;
            categorygraph.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            var valueAxis = categorygraph.xAxes.push(new am4charts.ValueAxis());
            valueAxis.cursorTooltipEnabled = false;

            // Create series
            var series = categorygraph.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueX = "value";
            series.dataFields.categoryY = "name";
            series.name = "value";
            series.tooltipText = "{categoryY}: [bold]{valueX}[/]";
            series.columns.template.fillOpacity = .8;
            series.columns.template.width = am4core.percent(40);
            series.columns.template.height = am4core.percent(40);

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            columnTemplate.adapter.add("fill", function (fill, target) {
                return categorygraph.colors.getIndex(target.dataItem.index);
            });

            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return categorygraph.colors.getIndex(target.dataItem.index);
            });

            categorygraph.cursor = new am4charts.XYCursor();
            categorygraph.cursor.lineX.strokeOpacity = 0;
            categorygraph.cursor.lineY.strokeOpacity = 0;
            categorygraph.events.on("beforedatavalidated", function (ev) {
                categorygraph.data.sort(function (a, b) {
                    return (a.value) - (b.value);
                });
            });
            series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.columns.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?vulnerabilityName=' + ev.target.dataItem.dataContext.name;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            },
                    this
                    );
            categoryIndicator = categorygraph.tooltipContainer.createChild(am4core.Container);
            categoryIndicator.background.fill = am4core.color("#fff");
            categoryIndicator.background.fillOpacity = 0.8;
            categoryIndicator.width = am4core.percent(100);
            categoryIndicator.height = am4core.percent(100);

            var categoryIndicatorLabel = categoryIndicator.createChild(am4core.Label);
            categoryIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            categoryIndicatorLabel.align = "center";
            categoryIndicatorLabel.valign = "middle";
            categoryIndicatorLabel.fontSize = 12;
                $.post("category.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var counts = [];
            var categories = [];
            var combined = [];
            for (var i = 0; i < temp.length; i++) {
                if(temp[i].locale == "en") {
                      categories[i] = decodeHtml(temp[i].secondaryName);
                      counts[i] = temp[i].count;
                      combined[i] = {"name": categories[i], "id": temp[i].id, "value": counts[i]};
                }
                else{
                categories[i] = decodeHtml(temp[i].name);
                counts[i] = temp[i].count;
                combined[i] = {"name": categories[i], "id": temp[i].id, "value": counts[i]};
                }
            }
            if (0 === combined.length) {
                /*$('#categorygraph').removeAttr('style');
                 $('#categorygraph').css("text-align", "center");
                 $('#categorygraph').css("width:", "100%");
                 $('#categorygraph').css("height", "400px");
                 $('#categorygraph').css("line-height", "400px");
                 $('#categorygraph').text("<spring:message code="generic.emptyGraph"/>");*/
                categorygraph.data = [];
                categoryIndicator.show();
            } else {
                $('#categorygraph').css("line-height", "");
                categorygraph.data = combined;
                categoryIndicator.hide();
            }        
				
				$("#accordingToCategoryWait").hide();
                $("#categorygraph").show();
            });
        }
        function problemfunction() {             /////   PROBLEM ALANINA GÖRE ZAFİYETLERİN DAĞILIMI GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#problemvulnerabilities").html();
            if (problemvulnerabilities !== undefined)
                problemvulnerabilities.dispose();
            /* Zafiyet Kategorileri Tabı:  PROBLEM ALANINA GÖRE ZAFİYETLERİN DAĞILIMI */
            problemvulnerabilities = am4core.create("problemvulnerabilities", am4charts.PieChart3D);
            problemvulnerabilities.hiddenState.properties.opacity = 0; // this creates initial fade-in

            var series = problemvulnerabilities.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "value";
            series.dataFields.category = "name";
            series.ticks.template.disabled = true;
            series.alignLabels = false;
            series.labels.template.text = "{value.percent.formatNumber('#.0')}%";
            series.labels.template.radius = am4core.percent(10);
            series.labels.template.fill = am4core.color("black");

            var label = series.labels.template;
            label.truncate = true;
            label.maxWidth = 100;
            series.slices.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.slices.template.events.on("hit", function (ev) {
                var url = '../customer/listVulnerabilities.htm?problemAreaValue=' + ev.target.dataItem.dataContext.type;
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            }, this);

            problemvulnerabilitiesLegend = am4core.create("problemvulnerabilitiesLegend", am4core.Container);
            problemvulnerabilitiesLegend.width = am4core.percent(100);
            problemvulnerabilitiesLegend.height = am4core.percent(100);
            problemvulnerabilities.legend = new am4charts.Legend();
            problemvulnerabilities.legend.parent = problemvulnerabilitiesLegend;
            problemvulnerabilities.legend.scale = 0.6;
            problemvulnerabilities.legend.fontSize = 18;

            problemvulnerabilities.events.on("datavalidated", resizeLegend);
            problemvulnerabilities.events.on("maxsizechanged", resizeLegend);

            function resizeLegend(ev) {
                document.getElementById("problemvulnerabilitiesLegend").style.height = problemvulnerabilities.data.length*25 + "px";
            }


            problemvulnerabilitiesIndicator = problemvulnerabilities.tooltipContainer.createChild(am4core.Container);
            problemvulnerabilitiesIndicator.background.fill = am4core.color("#fff");
            problemvulnerabilitiesIndicator.background.fillOpacity = 0.8;
            problemvulnerabilitiesIndicator.width = am4core.percent(100);
            problemvulnerabilitiesIndicator.height = am4core.percent(100);

            var problemvulnerabilitiesIndicatorLabel = problemvulnerabilitiesIndicator.createChild(am4core.Label);
            problemvulnerabilitiesIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            problemvulnerabilitiesIndicatorLabel.align = "center";
            problemvulnerabilitiesIndicatorLabel.valign = "middle";
            problemvulnerabilitiesIndicatorLabel.fontSize = 12;
                $.post("problem.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var counts = [];
            for (var i = 0; i < temp.length; i++) {
                counts[i] = {"name": decodeHtml(temp[i].value), "type": temp[i].name, "value": temp[i].count};
            }
            if (0 === counts.length) {
                /* $('#problemvulnerabilities').removeAttr('style');
                 $('#problemvulnerabilities').css("text-align", "center");
                 $('#problemvulnerabilities').css("width:", "100%");
                 $('#problemvulnerabilities').css("height", "400px");
                 $('#problemvulnerabilities').css("line-height", "400px");
                 $('#problemvulnerabilities').text("<spring:message code="generic.emptyGraph"/>"); */
                problemvulnerabilities.data = [];
                problemvulnerabilitiesIndicator.show();
            } else {
                $('#problemvulnerabilities').css("line-height", "");
                problemvulnerabilities.data = counts;
                problemvulnerabilitiesIndicator.hide();
            }
				
		$("#accordingToProblemAreaWait").hide();
                $("#problemvulnerabilities").show();

            });
        }
        function categoryTable() {             /////   RİSK KATEGORİLERİNE GÖRE BULGULARIN DAĞILIMI TABLOSU   /////
            var oTable;
                var obj = getObjectByForm("searchForm");
                oTable = $('#serverDatatables').dataTable({
                    "language": {
                        "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                        "processing": "<spring:message code="generic.tableLoading"/>",
                        "search": "<spring:message code="generic.search"/>  ",
                        "paginate": {
                            "next": "<spring:message code="generic.next"/>",
                            "previous": "<spring:message code="generic.back"/>"
                        },
                        "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                        "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>'
                    },
                    "bDestroy": true,
                    "searching": false,
                    "processing": true,
                    "serverSide": true,
                    "stateSave": true,
                    "scrollX": true,
                    "info": false,
                    "bLengthChange": false,
                    "sDom": 'ft',
                    "columns": [
                        {"data": 'name'},
                        {"data": 'level5',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var html = '<a href="../customer/listVulnerabilities.htm?categoryValue=' + oData.id + '&level=5';
                                html = addFilterToUrl(html);
                                html += '" target="_blank" style="color:white;font-size:14px;">';
                                html += '<div class = riskScore riskLevel5; style="margin:auto;width:100px;text-align:center;padding-top:3px;height:30px;border: 1px solid #e78f08;background-color:#F80812;border-radius:5px"><b>' + oData.level5 + '</b></div>';
                                html += '</a>';
                                $(nTd).html(html);
                            }},
                        {"data": 'level4',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var html = '<a href="../customer/listVulnerabilities.htm?categoryValue=' + oData.id + '&level=4';
                                html = addFilterToUrl(html);
                                html += '" target="_blank" style="color:white;font-size:14px;">';
                                html += '<div class = riskScore riskLevel5; style="margin:auto;width:100px;text-align:center;padding-top:3px;height:30px;border: 1px solid #e78f08;background-color:#F88008;border-radius:5px"><b>' + oData.level4 + '</b></div>';
                                html += '</a>';
                                $(nTd).html(html);
                            }},
                        {"data": 'level3',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var html = '<a href="../customer/listVulnerabilities.htm?categoryValue=' + oData.id + '&level=3';
                                html = addFilterToUrl(html);
                                html += '" target="_blank" style="color:black;font-size:14px;">';
                                html += '<div class = riskScore riskLevel5; style="margin:auto;width:100px;text-align:center;padding-top:3px;height:30px;border: 1px solid #e78f08;background-color:#F8C508;border-radius:5px"><b>' + oData.level3 + '</b></div>';
                                html += '</a>';
                                $(nTd).html(html);
                            }},
                        {"data": 'level2',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var html = '<a href="../customer/listVulnerabilities.htm?categoryValue=' + oData.id + '&level=2';
                                html = addFilterToUrl(html);
                                html += '" target="_blank" style="color:black;font-size:14px;">';
                                html += '<div class = riskScore riskLevel5; style="margin:auto;width:100px;text-align:center;padding-top:3px;height:30px;border: 1px solid #e78f08;background-color:#FEFE60;border-radius:5px"><b>' + oData.level2 + '</b></div>';
                                html += '</a>';
                                $(nTd).html(html);
                            }},
                        {"data": 'level1',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var html = '<a href="../customer/listVulnerabilities.htm?categoryValue=' + oData.id + '&level=1';
                                html = addFilterToUrl(html);
                                html += '" target="_blank" style="color:black;font-size:14px;">';
                                html += '<div class = riskScore riskLevel5; style="margin:auto;width:100px;text-align:center;padding-top:3px;height:30px;border: 1px solid #e78f08;background-color:#F9FABB;border-radius:5px"><b>' + oData.level1 + '</b></div>';
                                html += '</a>';
                                $(nTd).html(html);
                            }},
                        {"data": 'total',
                            "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                                var html = '<a href="../customer/listVulnerabilities.htm?categoryValue=' + oData.id;
                                html = addFilterToUrl(html);
                                html += '" target="_blank" style="color:black;font-size:14px;">';
                                html += '<div class = riskScore riskLevel5; style="margin:auto;width:100px;text-align:center;padding-top:3px;height:30px;border: 1px solid #e78f08;background-color:#fff;border-radius:5px"><b>' + oData.total + '</b></div>';
                                html += '</a>';
                                $(nTd).html(html);
                            }}
                    ],
                    "ajax": {
                        "type": "POST",
                        "url": "loadCategories.json",
                        "data": obj,
                        "error": function (jqXHR, textStatus, errorThrown) {
                            if(jqXHR.status === 403) {
                                window.location = '../error/userForbidden.htm';
                            } else {
                                console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                                $("#alertModalBody").empty();
                                $("#alertModalBody").html("<spring:message code="listCategories.tableError"/>");
                                $("#alertModal").modal("show");
                            }
                        }
                    },
                    "initComplete": function (settings, json) {
                        $('[data-toggle="tooltip"]').tooltip();
                    }
                });
            }

        //-----------------------------------------------------     PERFORMANS TABI     -----------------------------------------------------//

        function levelOpenClosedCountFunction() {        /////   SEVİYEYE GÖRE AÇIK/KAPALI ZAFİYET GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            /* Performans Tabı:  PROBLEM ALANINA GÖRE ZAFİYETLERİN DAĞILIMI */
            $("#levelOpenClosedCountGraph").html();
            if (levelOpenClosedCountGraph !== undefined)
                levelOpenClosedCountGraph.dispose();
            levelOpenClosedCountGraph = am4core.create("levelOpenClosedCountGraph", am4charts.XYChart3D);
            levelOpenClosedCountGraph.data = [];

            // Create axes
            var categoryAxis = levelOpenClosedCountGraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";
            categoryAxis.renderer.grid.template.location = 0;
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 20;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.label.rotation = 270;
            categoryAxis.tooltip.label.horizontalCenter = "right";
            categoryAxis.tooltip.label.verticalCenter = "middle";
            levelOpenClosedCountGraph.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });
            // Configure axis label
            var label = categoryAxis.renderer.labels.template;
            label.wrap = true;

            var valueAxis = levelOpenClosedCountGraph.yAxes.push(new am4charts.ValueAxis());
            valueAxis.min = 0;
            valueAxis.calculateTotals = true;
            // Create series
            function createLevelOpenClosedCountGraphSeries(field, name,levelValues) {

                // Set up series
                var series = levelOpenClosedCountGraph.series.push(new am4charts.ColumnSeries3D());
                series.name = name;
                series.dataFields.valueY = field;
                series.dataFields.categoryX = "name";
                series.sequencedInterpolation = true;
                series.stroke = am4core.color("#ffffff");
                
                var columnTemplate = series.columns.template;
                columnTemplate.tooltipText = "{categoryX}: [bold]{valueY}[/]";
                columnTemplate.fillOpacity = .8;
                columnTemplate.strokeOpacity = 0;
                columnTemplate.fill = am4core.color("#5a5");

                if (field === 'open')
                   {
                       series.columns.template.adapter.add("fill", function(fill, target) {
                            var level = target.dataItem.column.dataItem.categoryX;
                           switch(level){
                               case '<spring:message code="dashboard.level5"/>':
                                   return am4core.color("#d91e18");
                                   break;
                               case '<spring:message code="dashboard.level4"/>':
                                   return am4core.color("#f88008");
                                   break;
                               case '<spring:message code="dashboard.level3"/>':
                                   return am4core.color("#f8c508");
                                   break;
                               case '<spring:message code="dashboard.level2"/>':
                                   return am4core.color("#fefe60");
                                   break;
                               case '<spring:message code="dashboard.level1"/>':
                                   return am4core.color("#f9fabb");
                                   break;
                       }
                });
                   }
                else if (field === 'closed')
                    series.columns.template.fill = am4core.color("#4682b4");

                // Make it stacked
                series.stacked = true;

                // Configure columns
                series.columns.template.width = am4core.percent(60);
                series.columns.template.fillOpacity = .8;
                series.columns.template.tooltipText = "[font-size:14px]" + series.name + ": {valueY}";

                // Add label
                var labelBullet = series.bullets.push(new am4charts.LabelBullet());
                if (field === "closed") {
                    labelBullet.label.text = "[font-size: 15px]{valueY.total}[/]";
                    labelBullet.label.dy = -15;
                    labelBullet.label.verticalCenter = "bottom";
                    levelOpenClosedCountGraph.maskBullets = false;
                }
                series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
                series.columns.template.events.on("hit", function (ev) {
                    if (ev.target.dom.attributes['fill'].nodeValue === ev.target.dataItem.dataContext.openColor) {
                        var url = '../customer/listVulnerabilities.htm?level=' + ev.target.dataItem.dataContext.level + '&statusValues=OPEN,RISK_ACCEPTED,RECHECK,ON_HOLD,IN_PROGRESS';
                    } else if (ev.target.dom.attributes['fill'].nodeValue === ev.target.dataItem.dataContext.closedColor) {
                        var url = '../customer/listVulnerabilities.htm?level=' + ev.target.dataItem.dataContext.level + '&statusValues=CLOSED';
                    } else {
                        var url = '../customer/listVulnerabilities.htm?level=' + ev.target.dataItem.dataContext.level;
                    }
                    url = addFilterToUrl(url);
                    window.open(url, '_blank');
                },
                        this
                        );
                return series;
            }
            

            levelOpenClosedCountIndicator = levelOpenClosedCountGraph.tooltipContainer.createChild(am4core.Container);
            levelOpenClosedCountIndicator.background.fill = am4core.color("#fff");
            levelOpenClosedCountIndicator.background.fillOpacity = 0.8;
            levelOpenClosedCountIndicator.width = am4core.percent(100);
            levelOpenClosedCountIndicator.height = am4core.percent(100);

            var levelOpenClosedCountIndicatorLabel = levelOpenClosedCountIndicator.createChild(am4core.Label);
            levelOpenClosedCountIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            levelOpenClosedCountIndicatorLabel.align = "center";
            levelOpenClosedCountIndicatorLabel.valign = "middle";
            levelOpenClosedCountIndicatorLabel.fontSize = 12;
                $.post("levelOpenClosedCount.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var openCount = [];
            var closedCount = [];
            var levels = ["", "<spring:message code="dashboard.level1"/>", "<spring:message code="dashboard.level2"/>", "<spring:message code="dashboard.level3"/>",
                "<spring:message code="dashboard.level4"/>", "<spring:message code="dashboard.level5"/>"];
            var levelValues = [];
            for (var i = 0; i < temp.length; i++) {
                openCount[i] = {name: <c:out value = "temp[i].level"/>, y: <c:out value = "temp[i].open"/>};
                closedCount[i] = {name: <c:out value = "temp[i].level"/>, y: <c:out value = "temp[i].closed"/>};
            }
            for (var s = 0; s < temp.length; s++) {
                levelValues[s] = {
                    "name": <c:out value = "levels[temp[s].level]"/>,
                    "level": <c:out value = "temp[s].level"/>,
                    "closed": <c:out value = "closedCount[s].y"/>,
                    "open": <c:out value = "openCount[s].y"/>,
                    "closedColor": '#4682b4',
                    "openColor": '#d91e18'};
            }
            createLevelOpenClosedCountGraphSeries("open", "<spring:message code="dashboard.open"/>",levelValues);
            createLevelOpenClosedCountGraphSeries("closed", "<spring:message code="dashboard.close"/>",levelValues);
            if (0 === levelValues.length) {
                /*$('#levelOpenClosedCountGraph').removeAttr('style');
                 $('#levelOpenClosedCountGraph').css("text-align", "center");
                 $('#levelOpenClosedCountGraph').css("width:", "100%");
                 $('#levelOpenClosedCountGraph').css("height", "400px");
                 $('#levelOpenClosedCountGraph').css("line-height", "400px");
                 $('#levelOpenClosedCountGraph').text("<spring:message code="generic.emptyGraph"/>");*/
                levelOpenClosedCountGraph.data = [];
                levelOpenClosedCountIndicator.show();
            } else {
                $('#levelOpenClosedCountGraph').css("line-height", "");
                levelOpenClosedCountGraph.data = levelValues;
                levelOpenClosedCountIndicator.hide();

            }
                
                $("#levelOpenClosedCountGraphWait").hide();
                $("#levelOpenClosedCountGraph").show();
            });
        }
        function timefunction() {               /////   ZAFİYETLERİN ZAMANA GÖRE EKLENME GRAFİĞİ   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#timegraph").html();
            if (timegraph !== undefined)
                timegraph.dispose();
            /* Performans Tabı:   ZAFİYETLERİN ZAMANA GÖRE EKLENME GRAFİĞİ */
            timegraph = am4core.create("timegraph", am4charts.XYChart);
            timegraph.dateFormatter.dateFormat = "yyyy-MMM-dd";
        <c:choose>
            <c:when test="${selectedLanguage == 'en'}">
            </c:when>
            <c:when test="${selectedLanguage == 'tr'}">
            timegraph.language.locale = am4lang_tr_TR;
            </c:when>
        </c:choose>
            timegraph.paddingRight = 20;

            // Increase contrast by taking evey second color
            timegraph.colors.step = 2;
            timegraph.scrollbarX = new am4core.Scrollbar();
            timegraph.scrollbarX.parent = timegraph.topAxesContainer;
            timegraph.scrollbarX.marginTop = 0;
            timegraph.scrollbarX.toBack();
            // Create axes
            var dateAxis = timegraph.xAxes.push(new am4charts.DateAxis());
            dateAxis.dateFormatter = new am4core.DateFormatter();
            dateAxis.dateFormats.setKey("month", "yyyy-MMM-dd");
            dateAxis.periodChangeDateFormats.setKey("month", "yyyy-MMM-dd");
            dateAxis.dateFormatter.dateFormat = "dd-MM-yyyy";
            dateAxis.renderer.minGridDistance = 50;
            dateAxis.renderer.grid.template.location = 0;
            dateAxis.startLocation = 0.5;
            dateAxis.endLocation = 0.5;
            dateAxis.renderer.minLabelPosition = 0.05;
            dateAxis.renderer.maxLabelPosition = 0.95;


            dateAxis.dataFields.category = "day";
            dateAxis.renderer.minGridDistance = 60;

            var valueAxis = timegraph.yAxes.push(new am4charts.ValueAxis());
            // Create series
            function createAxisAndSeries(field, name, opposite, color) {

                var series = timegraph.series.push(new am4charts.LineSeries());
                series.dataFields.valueY = field;
                series.dataFields.dateX = "day";
                series.tooltipText = "{value}";
                series.strokeWidth = 3;
                series.tooltip.background.cornerRadius = 20;
                series.tooltip.background.strokeOpacity = 0;
                series.tooltip.pointerOrientation = "vertical";
                series.tooltip.label.minWidth = 40;
                series.tooltip.label.minHeight = 40;
                series.tooltip.label.textAlign = "middle";
                series.tooltip.label.textValign = "middle";
                series.tooltipText = "{name}: [bold]{valueY}[/]";
                series.tooltip.getFillFromObject = false;
                series.tooltip.label.fill = am4core.color("#000000");
                series.strokeWidth = 2;
                series.yAxis = valueAxis;
                series.name = name;
                var bullet = series.bullets.push(new am4charts.CircleBullet());
                bullet.circle.strokeWidth = 2;
                bullet.circle.radius = 4;
                bullet.circle.fill = am4core.color("#fff");
                var bullethover = bullet.states.create("hover");
                bullethover.properties.scale = 1.3;
                if (color === 'level1') {
                    series.stroke = am4core.color("#F9FABB");
                    series.tooltip.background.fill = am4core.color("#F9FABB");
                } else if (color === 'level2') {
                    series.tooltip.background.fill = am4core.color("#FEFE60");
                    series.stroke = am4core.color("#FEFE60");
                } else if (color === 'level3') {
                    series.stroke = am4core.color("#F8C508");
                    series.tooltip.background.fill = am4core.color("#F8C508");
                } else if (color === 'level4') {
                    series.stroke = am4core.color("#F88008");
                    series.tooltip.background.fill = am4core.color("#F88008");
                } else if (color === 'level5') {
                    series.stroke = am4core.color("#D91E18");
                    series.tooltip.background.fill = am4core.color("#D91E18");
                }
                series.sequencedInterpolation = true;
                var bullet = series.bullets.push(new am4charts.CircleBullet());
                bullet.circle.strokeWidth = 2;
                bullet.circle.radius = 4;
                bullet.circle.fill = am4core.color("#fff");
                var bullethover = bullet.states.create("hover");
                bullethover.properties.scale = 1.3;
            }
            valueAxis.renderer.line.strokeOpacity = 1;
            valueAxis.renderer.line.strokeWidth = 2;
            valueAxis.renderer.opposite = false;
            valueAxis.renderer.grid.template.disabled = true;
            createAxisAndSeries("value1", "<spring:message code="dashboard.level1"/>", false, "level1");
            createAxisAndSeries("value2", "<spring:message code="dashboard.level2"/>", false, "level2");
            createAxisAndSeries("value3", "<spring:message code="dashboard.level3"/>", false, "level3");
            createAxisAndSeries("value4", "<spring:message code="dashboard.level4"/>", false, "level4");
            createAxisAndSeries("value5", "<spring:message code="dashboard.level5"/>", false, "level5");
            // Add legend
            //timegraph.legend = new am4charts.Legend();
            // Add cursor
            timegraph.cursor = new am4charts.XYCursor();
            timegraph.cursor.behavior = "panXY";
            timegraph.cursor.xAxis = dateAxis;
            timegraph.scrollbarX = new am4core.Scrollbar();
            timegraph.scrollbarX.parent = timegraph.topAxesContainer;
            timegraph.scrollbarX.marginTop = 0;
            timegraph.scrollbarX.toBack();
            timegraph.events.on("ready", function () {
                dateAxis.zoom({
                    start: 0.0,
                    end: 1
                });
            });
            timegraph.events.on("beforedatavalidated", function (ev) {
                timegraph.data.sort(function (a, b) {
                    return (new Date(a.date)) - (new Date(b.date));
                });
            });


            timeIndicator = timegraph.tooltipContainer.createChild(am4core.Container);
            timeIndicator.background.fill = am4core.color("#fff");
            timeIndicator.background.fillOpacity = 0.8;
            timeIndicator.width = am4core.percent(100);
            timeIndicator.height = am4core.percent(100);

            var timeIndicatorLabel = timeIndicator.createChild(am4core.Label);
            timeIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            timeIndicatorLabel.align = "center";
            timeIndicatorLabel.valign = "middle";
            timeIndicatorLabel.fontSize = 12;
                $.post("time.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var combinedtimegraph = [];
            for (var s = 0; s < temp.length; s++) {
                combinedtimegraph[s] = {
                    "day": <c:out value = "temp[s].date"/>,
                    "value1": <c:out value = "temp[s].level1count"/>,
                    "value2": <c:out value = "temp[s].level2count"/>,
                    "value3": <c:out value = "temp[s].level3count"/>,
                    "value4": <c:out value = "temp[s].level4count"/>,
                    "value5": <c:out value = "temp[s].level5count"/>};
            }
            if (0 === combinedtimegraph.length) {
                /*$('#timegraph').removeAttr('style');
                 $('#timegraph').css("text-align", "center");
                 $('#timegraph').css("width:", "100%");
                 $('#timegraph').css("height", "400px");
                 $('#timegraph').css("line-height", "400px");
                 $('#timegraph').text("<spring:message code="generic.emptyGraph"/>");*/
                timegraph.data = [];
                timeIndicator.show();

            } else {
                $('#timegraph').css("line-height", "");
                timegraph.data = combinedtimegraph;
                timeIndicator.hide();

            }        
                
                $("#timegraphWait").hide();
                $("#timegraph").show();
            });
        }
        function totaltimefunction() {                 /////   ZAFİYETLERİN ZAMANA GÖRE EKLENME GRAFİĞİ (KÜMÜLATİF)   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#totaltimegraph").html();
            if (totaltimegraph !== undefined)
                totaltimegraph.dispose();
            /* Performans Tabı:   ZAFİYETLERİN ZAMANA GÖRE EKLENME GRAFİĞİ (KÜMÜLATİF)*/
            totaltimegraph = am4core.create("totaltimegraph", am4charts.XYChart);
        <c:choose>
            <c:when test="${selectedLanguage == 'en'}">
            </c:when>
            <c:when test="${selectedLanguage == 'tr'}">
            totaltimegraph.language.locale = am4lang_tr_TR;
            </c:when>
        </c:choose>

            // Increase contrast by taking evey second color
            totaltimegraph.colors.step = 2;
            totaltimegraph.scrollbarX = new am4core.Scrollbar();
            totaltimegraph.scrollbarX.parent = totaltimegraph.topAxesContainer;
            totaltimegraph.scrollbarX.marginTop = 0;
            totaltimegraph.scrollbarX.toBack();
            // Create axes
            var dateAxis = totaltimegraph.xAxes.push(new am4charts.DateAxis());
            dateAxis.dateFormatter = new am4core.DateFormatter();
            dateAxis.dateFormatter.dateFormat = "yyyy-MMM-dd";
            dateAxis.dateFormats.setKey("month", "yyyy-MMM-dd");
            dateAxis.periodChangeDateFormats.setKey("month", "yyyy-MMM-dd");
            dateAxis.renderer.minGridDistance = 70;
            dateAxis.renderer.grid.template.location = 0;
            dateAxis.startLocation = 0.4;
            dateAxis.endLocation = 0.6;
            dateAxis.renderer.minLabelPosition = 0.05;
            dateAxis.renderer.maxLabelPosition = 0.95;
            dateAxis.dataFields.dateX = "totalday";
            var valueAxis = totaltimegraph.yAxes.push(new am4charts.ValueAxis());
            // Create series
            function createTotalTimeGraphAxisAndSeries(field, name, opposite, color) {
                var series = totaltimegraph.series.push(new am4charts.LineSeries());
                series.dataFields.valueY = field;
                series.dataFields.dateX = "totalday";
                series.tooltipText = "{value}";
                series.strokeWidth = 3;
                series.tooltip.background.cornerRadius = 20;
                series.tooltip.background.strokeOpacity = 0;
                series.tooltip.pointerOrientation = "vertical";
                series.tooltip.label.minWidth = 40;
                series.tooltip.label.minHeight = 40;
                series.tooltip.label.textAlign = "middle";
                series.tooltip.label.textValign = "middle";
                series.tooltipText = "{name}: [bold]{valueY}[/]";
                series.tooltip.getFillFromObject = false;
                series.tooltip.label.fill = am4core.color("#000000");
                series.strokeWidth = 2;
                series.yAxis = valueAxis;
                series.name = name;


                var bullet = series.bullets.push(new am4charts.CircleBullet());
                bullet.circle.strokeWidth = 2;
                bullet.circle.radius = 4;
                bullet.circle.fill = am4core.color("#fff");
                var bullethover = bullet.states.create("hover");
                bullethover.properties.scale = 1.3;
                if (color === 'level1') {
                    series.stroke = am4core.color("#F9FABB");
                    series.tooltip.background.fill = am4core.color("#F9FABB");
                } else if (color === 'level2') {
                    series.tooltip.background.fill = am4core.color("#FEFE60");
                    series.stroke = am4core.color("#FEFE60");
                } else if (color === 'level3') {
                    series.stroke = am4core.color("#F8C508");
                    series.tooltip.background.fill = am4core.color("#F8C508");
                } else if (color === 'level4') {
                    series.stroke = am4core.color("#F88008");
                    series.tooltip.background.fill = am4core.color("#F88008");
                } else if (color === 'level5') {
                    series.stroke = am4core.color("#D91E18");
                    series.tooltip.background.fill = am4core.color("#D91E18");
                }
                series.sequencedInterpolation = true;

            }
            valueAxis.renderer.line.strokeOpacity = 1;
            valueAxis.renderer.line.strokeWidth = 2;
            valueAxis.renderer.opposite = false;
            valueAxis.renderer.grid.template.disabled = true;
            createTotalTimeGraphAxisAndSeries("totalvalue1", "<spring:message code="dashboard.level1"/>", false, "level1");
            createTotalTimeGraphAxisAndSeries("totalvalue2", "<spring:message code="dashboard.level2"/>", false, "level2");
            createTotalTimeGraphAxisAndSeries("totalvalue3", "<spring:message code="dashboard.level3"/>", false, "level3");
            createTotalTimeGraphAxisAndSeries("totalvalue4", "<spring:message code="dashboard.level4"/>", false, "level4");
            createTotalTimeGraphAxisAndSeries("totalvalue5", "<spring:message code="dashboard.level5"/>", false, "level5");

            // Add cursor
            totaltimegraph.cursor = new am4charts.XYCursor();

            totaltimegraph.events.on("beforedatavalidated", function (ev) {
                totaltimegraph.data.sort(function (a, b) {
                    return (new Date(a.date)) - (new Date(b.date));
                });
            });

            totaltimeIndicator = totaltimegraph.tooltipContainer.createChild(am4core.Container);
            totaltimeIndicator.background.fill = am4core.color("#fff");
            totaltimeIndicator.background.fillOpacity = 0.8;
            totaltimeIndicator.width = am4core.percent(100);
            totaltimeIndicator.height = am4core.percent(100);

            var totaltimeIndicatorLabel = totaltimeIndicator.createChild(am4core.Label);
            totaltimeIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            totaltimeIndicatorLabel.align = "center";
            totaltimeIndicatorLabel.valign = "middle";
            totaltimeIndicatorLabel.fontSize = 12;

                $.post("totaltime.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var combinedtimegraph = [];
            for (var s = 0; s < temp.length; s++) {
                combinedtimegraph[s] = {
                    "totalday": <c:out value = "temp[s].date"/>,
                    "totalvalue1": <c:out value = "temp[s].level1count"/>,
                    "totalvalue2": <c:out value = "temp[s].level2count"/>,
                    "totalvalue3": <c:out value = "temp[s].level3count"/>,
                    "totalvalue4": <c:out value = "temp[s].level4count"/>,
                    "totalvalue5": <c:out value = "temp[s].level5count"/>};
            }
            if (0 === combinedtimegraph.length) {
                /* $('#totaltimegraph').removeAttr('style');
                 $('#totaltimegraph').css("text-align", "center");
                 $('#totaltimegraph').css("width:", "100%");
                 $('#totaltimegraph').css("height", "400px");
                 $('#totaltimegraph').css("line-height", "400px");
                 $('#totaltimegraph').text("<spring:message code="generic.emptyGraph"/>");*/
                totaltimegraph.data = [];
                totaltimeIndicator.show();
            } else {
                $('#totaltimegraph').css("line-height", "");
                totaltimegraph.data = combinedtimegraph;
                totaltimeIndicator.hide();
            }        
                
                $("#totaltimegraphWait").hide();
                $("#totaltimegraph").show();
                
               
            });
        }
        function totalManualAddedVulFunction() {                 /////   ZAFİYETLERİN ZAMANA GÖRE EKLENME GRAFİĞİ (KÜMÜLATİF)   /////
            var temp;
            var obj = getObjectByForm("searchForm");
            $("#totalManualAddedVulGraph").html();
            if (totalManualAddedVulGraph !== undefined)
                totalManualAddedVulGraph.dispose();
            /* Performans Tabı: KULLANICILARA GÖRE GÜNLÜK ZAFİYET GİRİŞİ (KÜMÜLATİF)*/

            totalManualAddedVulGraph = am4core.create("totalManualAddedVulGraph", am4charts.XYChart);

        <c:choose>
            <c:when test="${selectedLanguage == 'en'}">
            </c:when>
            <c:when test="${selectedLanguage == 'tr'}">
            totalManualAddedVulGraph.language.locale = am4lang_tr_TR;
            </c:when>
        </c:choose>
            totalManualAddedVulGraph.paddingRight = 20;

            // Create axes
            var dateAxis = totalManualAddedVulGraph.xAxes.push(new am4charts.DateAxis());
            dateAxis.dateFormatter = new am4core.DateFormatter();
            dateAxis.dateFormats.setKey("month", "yyyy-MMM-dd");
            dateAxis.periodChangeDateFormats.setKey("month", "yyyy-MMM-dd");
            dateAxis.dateFormatter.dateFormat = "yyyy-MMM-dd";
            dateAxis.renderer.minGridDistance = 70;
            dateAxis.renderer.grid.template.location = 0;
            dateAxis.startLocation = 0.5;
            dateAxis.endLocation = 0.5;
            dateAxis.renderer.minLabelPosition = 0.05;
            dateAxis.renderer.maxLabelPosition = 0.95;
            dateAxis.skipEmptyPeriods = true;
            // Create value axis
            var valueAxis = totalManualAddedVulGraph.yAxes.push(new am4charts.ValueAxis());
            valueAxis.renderer.inside = true;
            valueAxis.renderer.maxLabelPosition = 0.99;
            valueAxis.renderer.labels.template.dy = -20;
                        
            // Create series
            function createTotalManualAddedVulGraphAxisAndSeries(field, name, opposite, user) {
                var lineSeries = totalManualAddedVulGraph.series.push(new am4charts.LineSeries());
                lineSeries.dataFields.valueY = field;
                lineSeries.dataFields.dateX = "date";
                lineSeries.tooltipText = "{name}: [bold]{valueY}[/]";
                lineSeries.strokeWidth = 3;
                lineSeries.tooltip.background.cornerRadius = 20;
                lineSeries.tooltip.background.strokeOpacity = 0;
                lineSeries.tooltip.pointerOrientation = "vertical";
                lineSeries.tooltip.label.minWidth = 40;
                lineSeries.tooltip.label.minHeight = 40;
                lineSeries.tooltip.label.textAlign = "middle";
                lineSeries.tooltip.label.textValign = "middle";
                lineSeries.tooltip.getFillFromObject = true;
                lineSeries.name = user;

                var bullet = lineSeries.bullets.push(new am4charts.CircleBullet());
                bullet.circle.strokeWidth = 2;
                bullet.circle.radius = 3;
                bullet.circle.fill = am4core.color("#fff");
                var bullethover = bullet.states.create("hover");
                bullethover.properties.scale = 1.3;
            }
            // Make a panning cursor
            totalManualAddedVulGraph.cursor = new am4charts.XYCursor();
            totalManualAddedVulGraph.cursor.behavior = "panXY";
            totalManualAddedVulGraph.cursor.xAxis = dateAxis;
            //totalManualAddedVulGraph.cursor.snapToSeries = lineSeries;
            totalManualAddedVulGraph.scrollbarX = new am4core.Scrollbar();
            totalManualAddedVulGraph.scrollbarX.parent = totalManualAddedVulGraph.topAxesContainer;
            totalManualAddedVulGraph.scrollbarX.marginTop = 0;
            totalManualAddedVulGraph.scrollbarX.toBack();
            totalManualAddedVulGraph.events.on("ready", function () {
                dateAxis.zoom({
                    start: 0.0,
                    end: 1
                });
            });
            totalManualAddedVulGraph.cursor = new am4charts.XYCursor();
            totalManualAddedVulGraph.legend = new am4charts.Legend();
            totalManualAddedVulGraph.legend.markers.template.disabled = false;
             
            totalManualAddedVulIndicator = totalManualAddedVulGraph.tooltipContainer.createChild(am4core.Container);
            totalManualAddedVulIndicator.background.fill = am4core.color("#fff");
            totalManualAddedVulIndicator.background.fillOpacity = 0.8;
            totalManualAddedVulIndicator.width = am4core.percent(100);
            totalManualAddedVulIndicator.height = am4core.percent(100);

            var totalManualAddedVulIndicatorLabel = totalManualAddedVulIndicator.createChild(am4core.Label);
            totalManualAddedVulIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            totalManualAddedVulIndicatorLabel.align = "center";
            totalManualAddedVulIndicatorLabel.valign = "middle";
            totalManualAddedVulIndicatorLabel.fontSize = 12;
            
            $.post("dailyTotalManualVulnerability.json", obj).done(function (result) {
                temp = result;
            }).fail(function (jqXHR, textStatus, errorThrown) {
                if(jqXHR.status === 403) {
                    window.location = '../error/userForbidden.htm';
                }
            }).always(function () {
                var combinedtimegraph = [];
                var user1total = user2total = user3total = user4total = user5total = 0;
                for (let s = 0; s < temp[1].length; s++) {
                    var map = {};
                    map["date"] = <c:out value = "temp[1][s].date"/>;
                    user1total += <c:out value = "temp[1][s].user1"/>;
                    user2total += <c:out value = "temp[1][s].user2"/>;
                    user3total += <c:out value = "temp[1][s].user3"/>;
                    user4total += <c:out value = "temp[1][s].user4"/>;
                    user5total += <c:out value = "temp[1][s].user5"/>;
                    map["user1"] = user1total;
                    map["user2"] = user2total;
                    map["user3"] = user3total;
                    map["user4"] = user4total;
                    map["user5"] = user5total;
                    map["user1value"] = (typeof temp[0][0] === 'undefined') ? "-" : temp[0][0];
                    map["user2value"] = (typeof temp[0][1] === 'undefined') ? "-" : temp[0][1];
                    map["user3value"] = (typeof temp[0][2] === 'undefined') ? "-" : temp[0][2];
                    map["user4value"] = (typeof temp[0][3] === 'undefined') ? "-" : temp[0][3];
                    map["user5value"] = (typeof temp[0][4] === 'undefined') ? "-" : temp[0][4];
   
                    combinedtimegraph[s] = map;
                }
                if (user1total !== 0) {
                    createTotalManualAddedVulGraphAxisAndSeries("user1", "<spring:message code="dashboard.level1"/>", false, temp[0][0]);             
                }
                if (user2total !== 0) {
                    createTotalManualAddedVulGraphAxisAndSeries("user2", "<spring:message code="dashboard.level2"/>", false, temp[0][1]);                       
                }
                if (user3total !== 0) {
                    createTotalManualAddedVulGraphAxisAndSeries("user3", "<spring:message code="dashboard.level3"/>", false, temp[0][2]);
                }
                if (user4total !== 0) {
                    createTotalManualAddedVulGraphAxisAndSeries("user4", "<spring:message code="dashboard.level4"/>", false, temp[0][3]);
                }
                if (user5total !== 0) {
                    createTotalManualAddedVulGraphAxisAndSeries("user5", "<spring:message code="dashboard.level5"/>", false, temp[0][4]);
                }
                if (0 === combinedtimegraph.length) {
                    totalManualAddedVulGraph.data = [];
                    totalManualAddedVulIndicator.show();
                } else {
                    $('#totalManualAddedVulGraph').css("line-height", "");
                    totalManualAddedVulGraph.data = combinedtimegraph;
                    totalManualAddedVulIndicator.hide();
                }
                $("#totalManualAddedVulGraphWait").hide();
                $("#totalManualAddedVulGraph").show();

            });
        }
        function numberOfOpenVulnerabilitiesOnUserFunction() {        /////   SORUMLU KULLANICILARA GÖRE AÇIK ZAFİYET SAYILARI   /////
            var temp;
            var obj = getObjectByForm("searchForm");

            $("#numberOfOpenVulnerabilitiesOnUserGraph").html();
            if (numberOfOpenVulnerabilitiesOnUserGraph !== undefined)
                numberOfOpenVulnerabilitiesOnUserGraph.dispose();
            /* Zafiyet Tabı:  SORUMLU KULLANICILARA GÖRE AÇIK ZAFİYET SAYILARI*/
            numberOfOpenVulnerabilitiesOnUserGraph = am4core.create("numberOfOpenVulnerabilitiesOnUserGraph", am4charts.XYChart3D);
            // Create axes
            var categoryAxis = numberOfOpenVulnerabilitiesOnUserGraph.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "name";
            categoryAxis.renderer.labels.template.rotation = 315;
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 20;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.label.rotation = 270;
            categoryAxis.tooltip.label.horizontalCenter = "right";
            categoryAxis.tooltip.label.verticalCenter = "middle";
            categoryAxis.renderer.inversed = true;

            var label = categoryAxis.renderer.labels.template;
            label.wrap = true;
            label.maxWidth = 120;
            numberOfOpenVulnerabilitiesOnUserGraph.events.on("ready", function () {
                categoryAxis.zoom({
                    start: 0,
                    end: 1
                });
            });

            var valueAxis = numberOfOpenVulnerabilitiesOnUserGraph.yAxes.push(new am4charts.ValueAxis());

            // Create series
            var series = numberOfOpenVulnerabilitiesOnUserGraph.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueY = "value";
            series.dataFields.categoryX = "name";
            series.name = "value";
            series.tooltipText = "{categoryX}: [bold]{valueY}[/]";
            series.columns.template.fillOpacity = .8;
            series.columns.template.width = am4core.percent(40);
            series.columns.template.height = am4core.percent(40);

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            columnTemplate.adapter.add("fill", function (fill, target) {
                return numberOfOpenVulnerabilitiesOnUserGraph.colors.getIndex(target.dataItem.index);
            });

            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return numberOfOpenVulnerabilitiesOnUserGraph.colors.getIndex(target.dataItem.index);
            });

            numberOfOpenVulnerabilitiesOnUserGraph.cursor = new am4charts.XYCursor();
            numberOfOpenVulnerabilitiesOnUserGraph.cursor.lineX.strokeOpacity = 0;
            numberOfOpenVulnerabilitiesOnUserGraph.cursor.lineY.strokeOpacity = 0;
            numberOfOpenVulnerabilitiesOnUserGraph.events.on("beforedatavalidated", function (ev) {
                numberOfOpenVulnerabilitiesOnUserGraph.data.sort(function (a, b) {
                    return (a.value) - (b.value);
                });
            });
            series.columns.template.cursorOverStyle = am4core.MouseCursorStyle.pointer;
            series.columns.template.events.on("hit", function (ev) {
                if (ev.target.dataItem.dataContext.type === 'GROUP') {
                    var url = '../customer/listVulnerabilities.htm?assigneeValue=' + ev.target.dataItem.dataContext.id + '&statusValues=OPEN,RISK_ACCEPTED,RECHECK,ON_HOLD,IN_PROGRESS';
                } else {
                    var url = '../customer/listVulnerabilities.htm?assigneeValue=' + ev.target.dataItem.dataContext.id + '&statusValues=OPEN,RISK_ACCEPTED,RECHECK,ON_HOLD,IN_PROGRESS';
                }
                url = addFilterToUrl(url);
                window.open(url, '_blank');
            },
                    this
                    );
            numberOfOpenVulnerabilitiesOnUserIndicator = numberOfOpenVulnerabilitiesOnUserGraph.tooltipContainer.createChild(am4core.Container);
            numberOfOpenVulnerabilitiesOnUserIndicator.background.fill = am4core.color("#fff");
            numberOfOpenVulnerabilitiesOnUserIndicator.background.fillOpacity = 0.8;
            numberOfOpenVulnerabilitiesOnUserIndicator.width = am4core.percent(100);
            numberOfOpenVulnerabilitiesOnUserIndicator.height = am4core.percent(100);

            var numberOfOpenVulnerabilitiesOnUserIndicatorLabel = numberOfOpenVulnerabilitiesOnUserIndicator.createChild(am4core.Label);
            numberOfOpenVulnerabilitiesOnUserIndicatorLabel.text = "<spring:message code="generic.emptyGraph"/>";
            numberOfOpenVulnerabilitiesOnUserIndicatorLabel.align = "center";
            numberOfOpenVulnerabilitiesOnUserIndicatorLabel.valign = "middle";
            numberOfOpenVulnerabilitiesOnUserIndicatorLabel.fontSize = 12;
                $.post("numberOfOpenVulnerabilitiesOnUser.json", obj).done(function (result) {
                    temp = result;
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    if(jqXHR.status === 403) {
                        window.location = '../error/userForbidden.htm';
                    }
                }).always(function () {
            var combined = [];
            for (var i = 0; i < temp.length; i++) {
                combined[i] = {
                    "name": decodeHtml(<c:out value = "temp[i].name"/>),
                    "id": <c:out value = "temp[i].vulnerabilityId"/>,
                    "type": <c:out value = "temp[i].assignee"/>,
                    "value": <c:out value = "temp[i].count"/>};
            }
            if (0 === combined.length) {
                /*$('#numberOfOpenVulnerabilitiesOnUserGraph').removeAttr('style');
                 $('#numberOfOpenVulnerabilitiesOnUserGraph').css("text-align", "center");
                 $('#numberOfOpenVulnerabilitiesOnUserGraph').css("width:", "100%");
                 $('#numberOfOpenVulnerabilitiesOnUserGraph').css("height", "400px");
                 $('#numberOfOpenVulnerabilitiesOnUserGraph').css("line-height", "400px");
                 $('#numberOfOpenVulnerabilitiesOnUserGraph').text("<spring:message code="generic.emptyGraph"/>");*/
                numberOfOpenVulnerabilitiesOnUserGraph.data = [];
                numberOfOpenVulnerabilitiesOnUserIndicator.show();
            } else {
                $('#numberOfOpenVulnerabilitiesOnUserGraph').css("line-height", "");
                numberOfOpenVulnerabilitiesOnUserGraph.data = combined;
                numberOfOpenVulnerabilitiesOnUserIndicator.hide();
            }        
                
                $("#numberOfOpenVulnerabilitiesOnUserGraphWait").hide();
                $("#numberOfOpenVulnerabilitiesOnUserGraph").show();
                
            });
        }
        
      
        
        
        // FİLTRE UYGULANDIĞINDA
        function filterGraphs() {
        <sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER, ROLE_COMPANY_MANAGER_READONLY')">
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
            if(defaultFilter && ($("#sources").val().length > 0  || $("#scans").val().length > 0)) {
                defaultFilter = false;
            }
            if(defaultFilter) {
                $("#filtered").val(""); 
            } else {
                $("#filtered").val("on");
            } 
            count--;
            showAllVulnerability();
            countAss--;
            showAllAsset();
            riskTable();
            vulnByStatusFunction();
            smallRiskScoreFunction();
            riskEffectHeatmapGraphFunction();
            topTenWebAppVulnFunction();
        </sec:authorize>
            if ($('#assetsTabButton').hasClass("active")) {
                assetscore();
                top10ip();
                assetvuln();
                assetgroupsfunction();
            }
            if ($('#riskMeterTabButton').hasClass("active")) {
                vulnDayFunction();
                vulnDayTotalFunction();
                vulnDayStatusFunction();
                heatMapFunction();
            }
            if ($('#riskScoreTabButton').hasClass("active")) {
                dailyRiskScoreCharts();
            }
            if ($('#vulnerabilitiesTabButton').hasClass("active")) {
                levelcount();
                vulneffect();
                top10kb();
                rootcause();
                cveDistribution();
            }
            if ($('#portsTabButton').hasClass("active")) {
                ports();
                servicefunction();
                operatingsystemsfunction();
                assetsbyassetgroupfunction();
            }
            if ($('#categoriesTabButton').hasClass("active")) {
                categoryfunction();
                problemfunction();
                categoryTable();
            }
            if ($('#performanceTabButton').hasClass("active")) {
                levelOpenClosedCountFunction();
                timefunction();
                totaltimefunction();
                totalManualAddedVulFunction();
                numberOfOpenVulnerabilitiesOnUserFunction();
            }
        }
        function resetGraphs(){
            $("#filtered").val("");
            $("#sources").val("").trigger('change');
           // $("#groups").val("").trigger('change');
            $("#scans").val("").trigger('change');
            $("#riskLevels").val(["1","2","3","4","5"]).trigger('change');
            $("#statuses").val(["OPEN","RISK_ACCEPTED","RECHECK","ON_HOLD","IN_PROGRESS"]).trigger('change');
        }
        
      
        
        
    </script>
</sec:authorize>


<sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
    <li id="graphFilter" class="dropdown dropdown-quick-sidebar-toggler" style="float:right;list-style-type: none">
        <a href="javascript:;" class="" style="text-decoration:none;position: fixed;top: 55px;right:0%;z-index: 5000;background-color: rgba(60, 63, 82, 0.6);color:white;
           border-top-left-radius: 20px;border-bottom-left-radius: 20px;font-size: 16px;padding: 5px">
            <spring:message code="dashboard.graficFilter"/>  <i class="icon-login" id="reverseLogin" style="font-size:18px"></i>
        </a>
    </li>
</sec:authorize>
<c:if test="${not empty readonlyAssetGroups}">
    <span style="font-size: 12px; font-weight: 600;">
        <b><spring:message code="main.theme.assetTree"/> | </b>
        <c:forEach var="readonlyAssetGroupName" items="${readonlyAssetGroups}">
            <c:out value="${readonlyAssetGroupName}"/> |
        </c:forEach>
    </span>
</c:if>

<!---------------------------------------- SEVİYEYE GÖRE ZAFİYET SAYILARI ------------------------------------->
<sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER, ROLE_COMPANY_MANAGER_READONLY')">
    <sec:authorize access="hasRole('ROLE_COMPANY_MANAGER')">
    <c:if test="${not empty timeStamps}">
    <div class="row">        
        <div id="sliderDiv" class="col-md-12" style="margin-left: 1%;width: 90%;">
            <input type="text" class="js-range-slider" id="timeSlider" value="" style="display: none;" />
        </div>
    </div> 
    </c:if>
    </sec:authorize>
    <div class="row" style="z-index:-1;">
        <div class="loader"><span class="loader__dot"></span><span class="loader__dot"></span><span class="loader__dot"></span></div>
        
        <div class="same-height-container widget-thumb" style="overflow: visible;">
            <div class="col-lg-4" style="padding-left: 0px !important; padding-right: 3px !important; z-index: 5000 ">
                
                <div class="row" style="height:80px;padding-left: 10px;" >
                    <div class="col-md-4 col-sm-4 col-xs-6" style="padding: 2px; width: 19.5%; position: relative; top: 50%; transform: translateY(-50%);">
                        <a href="#" onclick="box5Redirect();
                                    return false;">
                            <div class="bizzy-topbox bizzy-color-urgent" id="topboxUrgent">
                                <div class="bizzy-topbox-text"><spring:message code="dashboard.urgentText"/></div>
                                <div class="bizzy-topbox-value" id="barLevel5"></div>
                            </div>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-4 col-sm-4 col-xs-6" style="padding: 2px; width: 19.5%;  position: relative; top: 50%; transform: translateY(-50%);">
                        <a href="#" onclick="box4Redirect();
                                    return false;">
                            <div class="bizzy-topbox bizzy-color-critical" id="topboxCritical">
                                <div class="bizzy-topbox-text"><spring:message code="dashboard.criticalText"/></div>
                                <div class="bizzy-topbox-value" id="barLevel4"></div>
                            </div>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-4 col-sm-4 col-xs-6" style="padding: 2px; width: 19.5%;  position: relative; top: 50%; transform: translateY(-50%);">
                        <a href="#" onclick="box3Redirect();
                                    return false;">
                            <div class="bizzy-topbox bizzy-color-high" id="topboxHigh">
                                <div class="bizzy-topbox-text"><spring:message code="dashboard.highText"/></div>
                                <div class="bizzy-topbox-value" id="barLevel3"></div>
                            </div>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-4 col-sm-4 col-xs-6" style="padding: 2px; width: 19.5%;  position: relative; top: 50%; transform: translateY(-50%);">
                        <a href="#" onclick="box2Redirect();
                                    return false;">
                            <div class="bizzy-topbox bizzy-color-medium" id="topboxMedium">
                                <div class="bizzy-topbox-text"><spring:message code="dashboard.mediumText"/></div>
                                <div class="bizzy-topbox-value" id="barLevel2"></div>
                            </div>
                        </a>
                    </div>
                    <div class="col-lg-3 col-md-4 col-sm-4 col-xs-6" style="padding: 2px; width: 19.5%;  position: relative; top: 50%; transform: translateY(-50%);">
                        <a href="#" onclick="box1Redirect();
                                    return false;">
                            <div class="bizzy-topbox bizzy-color-low" id="topboxLow">
                                <div class="bizzy-topbox-text"><spring:message code="dashboard.lowText"/></div>
                                <div class="bizzy-topbox-value" id="barLevel1"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="portlet light dark-index bordered shadow-soft" id="skoretable" style="height:240px;width:100%;margin-top:10px;border-radius:5px" >
                        <div style="margin-left:2px;">
                        <div class="col-xs-4" style="margin-top:8px;border-right: 1px solid #a7bdcd;">
                            <div id="riskGradePopover" style="cursor: pointer;height:114px;width:25%;">
                            
                                <b>
                                <img src="${context}/resources/logo/riskGradeZ.png" id="riskGradeImg" style="top: 0;left: 20;right: 20;bottom: 0;margin: auto;width:80%;position: absolute;padding-bottom:100px;"/>
                                <div style="height:114px;display:table;right:0;margin:auto">
                                <span id="riskGrade" style="display:table-cell;vertical-align:middle;padding-left: 1.4em;padding-top: 0.2em" title="<spring:message code="riskReport.title"/>" data-content="" ></span>
                           
                            </div>
                                </b>
                            
                        <div id="popover_content" class="popover_content">
                        </div>
                                </div>
                                <div>
                                    <div style="margin-top: 10px;"><b class="longTextWrap" style=" font-size: 12px;margin-top: 10px;"><spring:message code='calendar.today'/></b></div>
                                    <div style="margin-top: 10px;"><b class="longTextWrap" style=" font-size: 12px;margin-top: 10px;" ><spring:message code='dashboard.yesterday'/></b></div>
                                    <div style="margin-top: 10px;"><b class="longTextWrap" style=" font-size: 12px;margin-top: 10px;" ><spring:message code='dashboard.lastWeek'/></b></div>
                                    <div style="margin-top: 10px;"><b class="longTextWrap" style=" font-size: 12px;margin-top: 10px;" ><spring:message code='dashboard.lastMonth'/></b></div>
                                </div>
                    </div>
                    <div class="col-xs-8">
                        <div  id="riskBar" style="height:125px;width:60%;">
                                <div id="scoreBarProgress" style="font-size:0.7vw;background-color: black;width:1%;opacity:0.8;border-radius: 15px;margin-left:1%;top:22%;position: absolute;">&nbsp;</div>
                                            <c:choose>
                        <c:when test="${selectedLanguage == 'en'}">
                        <img src="${context}/resources/logo/scoreBarEn.png" style="position: absolute;top: 20%;left: 0;right: 0;bottom: 0;width:95%;opacity:0.7;padding-left: 1em"/>
                        </c:when>
                        <c:when test="${selectedLanguage == 'tr'}">
                        <img src="${context}/resources/logo/scoreBarTr.png" style="position: absolute;top: 20%;left: 0;right: 0;bottom: 0;width:95%;opacity:0.7;padding-left: 1em"/>
                        </c:when>
                        </c:choose>
                            </div>
                        
                        <div class="portlet-body portlet-body-black" style="height: 30%;margin-top: -10px; padding-left: 0px !important; padding-right: 0px !important;">
                                                 
                        <div id="riskScoreChangeDiv" style="width: 70%;height: 120px !important;">
                            
                            
					<div style="margin-top: 10px;">
                                            <span id="riskScoreToday"></span>
					</div>
					<div style="margin-top: 10px;">
                                            <span id="riskScoreYesterday"></span>
                                            (<span id="riskScoreDiffYesterday"></span>)
                                            <span id="circleYesterday"></span>
					</div>
					<div style="margin-top: 10px;">
                                            <span id="riskScoreLastWeek"></span>
                                            (<span id="riskScoreDiffLastWeek"></span>)
                                            <span id="circleLastWeek"></span>
					</div>
					<div style="margin-top: 10px;">
                                            <span id="riskScoreLastMonth"></span>
                                            (<span id="riskScoreDiffLastMonth"></span>)
                                            <span id="circleLastMonth"></span>
                                        </div>
                                    
                            </div>            
                        </div> 
                                      
                    </div>
                    </div>          
                </div>                
            </div>         
            <div class="col-lg-5" style="padding-left: 3px !important; padding-right: 3px !important;">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.vulnDayGraphTotal"/> </span>
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="vulnDayGraphTotalWait" style="height:130px;width:40%;margin-top: 150px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                    <div id="vulnDayGraphTotal"></div>
                                </div>
                            </div>
                        </div>
            <div class="col-lg-3" style="padding-left: 3px !important; padding-right: 0px !important;">
                <div id="donutchart" class="portlet light dark-index bordered shadow-soft" style="height: 93.5%;">
                    <div class="portlet-title portlet-title-black">
                        <div class="caption">
                            <span class="caption-subject font-dark bold uppercase longTextWrap"><spring:message code="vulnerabilityStatusGraph.title"/> </span>
                            <div class="bizzy-help-tip" style="right:7px;"><i class="fas fa-info-circle" style="color: #e9ecf3;"></i>
                                <p><spring:message code="tooltip.vulnerabilityStatusGraph"/></p>
                            </div>
                        </div>
                    </div>
                     <div id="donutchartWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                    </div>
                     
                         <div id="chartdiv" style="width: 150px;margin: auto;top:-5px;">
                           
                         </div>
                         
                    
                            <div id="legenddiv" style="width: 370px;margin: auto;right: 30px"></div>
                    
                    
                </div>
            </div>
        </div>
    </div>
</sec:authorize>
<!---------------------------------------- GRAFİK FİLTRESİ SIDE BARI ---------------------------------------->
<div class="leftFilter" style="display:none">
    <a id="graphExit" href="javascript:;" class="page-quick-sidebar-toggler"  >
        <i class="icon-login" style="font-size:22px"></i>
    </a>
    <div id="graphDiv" class="page-quick-sidebar-wrapper" data-close-on-body-click="false" style="background:#3C3F52; opacity: 0.9; ">
        <div class="page-quick-sidebar">
            <ul class="nav nav-tabs" style="background:#3C3F52">
                <li class="active">
                    <a href="javascript:;" data-target="#quick_sidebar_tab_1" data-toggle="tab" aria-expanded="true"> <spring:message code="dashboard.graficFilter"/>
                    </a>
                    <c:if test="${not empty timeStamps}">
                    <div class="portlet-title portlet-title-black">
                        <div class="caption">
                            <div class="bizzy-help-tip" style="right:10px; top:45px;" ><i class="fas fa-info-circle" style="color: #e9ecf3;"></i>
                                <p>  <spring:message code="tooltip.graphFilter"/> </p>
                            </div>
                        </div>
                    </div>
                    </c:if>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane page-quick-sidebar-chat active" id="quick_sidebar_tab_1">
                    <div class="page-quick-sidebar-list" style="position: relative; overflow: hidden; width: auto; height: 874px;">
                        <form:form id="searchForm">
                            <div class="page-quick-sidebar-chat-users" data-rail-color="#ddd" data-wrapper-class="page-quick-sidebar-list" data-height="874" data-initialized="1" style="overflow: hidden; width: auto; height: 874px">
                                <input id ="filtered" type="hidden" name="filtered" value=""/>
                                <h5 class="text-center" style="color:white"><spring:message code="listReports.status"/></h5>
                                <div class="text-center">
                                    <select id ="statuses" name="statuses" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 80%">
                                        <option value="OPEN" selected><spring:message code="genericdb.OPEN"/></option>
                                        <option value="CLOSED"><spring:message code="genericdb.CLOSED"/></option>
                                        <option value="RISK_ACCEPTED" selected><spring:message code="genericdb.RISK_ACCEPTED"/></option>
                                        <option value="RECHECK" selected><spring:message code="genericdb.RECHECK"/></option>
                                        <option value="ON_HOLD" selected><spring:message code="genericdb.ON_HOLD"/></option>
                                        <option value="IN_PROGRESS" selected><spring:message code="genericdb.IN_PROGRESS"/></option>                                    
                                        <option value="FALSE_POSITIVE"><spring:message code="genericdb.FALSE_POSITIVE"/></option>
                                    </select>
                                </div>
                                <br>
                                <h5 class="text-center" style="color:white"><spring:message code="listScans.source"/></h5>
                                <div class="text-center">
                                    <select id ="sources" name="sources" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 80%;">
                                        <c:forEach var="source" items="${sources}">
                                            <option value="<c:out value="${source.name}"/>"><c:out value="${source.value}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <br>
                                <h5 class="text-center" style="color:white"><spring:message code="vulnerability.riskLevel"/></h5>
                                <div class="text-center">
                                    <select id ="riskLevels" name="riskLevels" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 80%;">
                                        <option value=5 selected>5</option>
                                        <option value=4 selected>4</option>
                                        <option value=3 selected>3</option>
                                        <option value=2 selected>2</option>
                                        <option value=1 selected>1</option>
                                        <option value=0 >0</option>
                                    </select>
                                </div>

                                <br>
                                <h5 class="text-center" style="color:white"><spring:message code="addAssetGroup.group"/></h5>
                                 <div class="text-center" style="margin-left: 10%;">
                                    <select class="js-example-basic-multiple js-states form-control"  id ="groups" name="groups" path="vulnerability.assetGroupList" style="width:89%; ">                                                   
                                    </select>
                                </div>
                                <br>
                                <h5 class="text-center" style="color:white"><spring:message code="dashboard.scansCount"/></h5>
                                 <div class="text-center" style="margin-left: 10%;">
                                <select id ="scans" name="scans" class="js-example-basic js-states form-control" style="width: 89%;"> 
                               </select>
                                </div>
                                <br>
                                <div class="col-lg-12">
                                    <div class="col-lg-6 text-center">
                                        <button type="button" onclick="resetGraphs()" class="btn btn-default" id="reset"><spring:message code="index.graphFilterReset"/></button>
                                    </div>
                                    <div class="col-lg-6 text-center">
                                        <button type="button" onclick="filterGraphs()" class="btn btn-default" id="search" style=" margin:0 auto;display:block;"><spring:message code="generic.apply"/></button>
                                    </div>
                                </div>
                            </div>
                        </form:form>
                        <div class="slimScrollBar" style="background: rgb(187, 187, 187); width: 7px; position: absolute; top: 0px; opacity: 0.4; display: none; border-radius: 7px; z-index: 99; right: 1px; height: 874px;"></div><div class="slimScrollRail" style="width: 7px; height: 100%; position: absolute; top: 0px; display: none; border-radius: 7px; background: rgb(221, 221, 221); opacity: 0.2; z-index: 90; right: 1px;"></div></div>
                </div>
            </div>
        </div>
    </div>
</div>
<c:if test="${not empty error}">
    <div class="alert alert-danger">
        <spring:message code="${error}"></spring:message>
        </div>
</c:if>

<!---------------------------------------- KUTUCUKLARDAKİ SAYISAL BİLGİLER ---------------------------------------->

<sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER, ROLE_COMPANY_MANAGER_READONLY')">
    <div class="row" style="z-index:-1;margin-top: -20px">
        <div class="col-lg-4" style="padding-left: 10px !important; padding-right: 3px !important;">
            <div class="portlet light dark-index bordered shadow-soft" >
                <div class="portlet-title portlet-title-black">
                    <div class="caption">
                        <span class="caption-subject font-dark bold uppercase"><spring:message code="dashboard.assetRiskHeatmap"/></span>
                        <div class="bizzy-help-tip" style="right:10px;" ><i class="fas fa-info-circle" style="color: #e9ecf3;"></i>
                            <p><spring:message code="tooltip.assetRiskHeatmap"/></p>
                        </div>
                    </div>
                </div>
                <div class="portlet-body portlet-body-black" style="height: 258px;">
                    <div id="assetRiskDistGraphWait" style="height:170px;width:40%;margin-top: 110px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                        <div class="bounce1"></div>
                        <div class="bounce2"></div>
                        <div class="bounce3"></div>
                    </div> 
                    
                    <div id="assetRiskDistGraphContainer" style="width: 100%;height: 250px" ></div>
                </div>
            </div>
        </div>
        <div class="col-lg-4" style="padding-left: 3px !important; padding-right: 3px !important;">
            <div class="portlet light dark-index bordered shadow-soft">
                <div class="portlet-title portlet-title-black">
                    <div class="caption">
                        <span class="caption-subject font-dark bold uppercase"><spring:message code="smallOpenVulnDayGraph.title"/> / <spring:message code="riskScoreGraph.title"/></span>
                    </div>
                </div>
                <div class="portlet-body portlet-body-black" style="height: 258px;">
                    <div id="smallRiskScoreWait" style="left: 50%; top: 48.5%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                        <div class="bounce1"></div>
                        <div class="bounce2"></div>
                        <div class="bounce3"></div>
                    </div>
                    <div id="smallRiskScoreGraph" style="width: 100%;height: 250px"></div>
                    <span class="widget-thumb-subtitle longTextWrap">&nbsp</span>
                </div>
            </div>
        </div>
            <div class="col-lg-4" style="padding-left: 3px !important; padding-right: 10px !important;">
                <!-- BEGIN Portlet PORTLET-->
                <div id="alertbox" class="portlet light dark-index bordered shadow-soft" style="height: 88%;margin: 0px">
                    <div class="portlet-title portlet-title-black">
                        <div class="caption">
                            <span class="caption-subject font-dark bold uppercase"><spring:message code="dashboard.riskEffectHeatmapGraph"/></span>
                            <div class="bizzy-help-tip" style="right:18px;" ><i class="fas fa-info-circle" style="color: #e9ecf3;"></i>
                                <p>  <spring:message code="tooltip.riskEffectHeatmapGraph"/></p>
                            </div>
                        </div>
                    </div>
                    <div class="portlet-body portlet-body-black" style="height: 258px;">
                         <div id="riskEffectHeatmapGraphWait" style="left: 50%; top: 48.5%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                            <div class="bounce1"></div>
                            <div class="bounce2"></div>
                            <div class="bounce3"></div>
                        </div>  
                        <div id="riskEffectHeatmapGraph" style="width: 100%;height: 240px !important"></div>
                        <span class="widget-thumb-subtitle longTextWrap">&nbsp</span>
                    </div>
                </div>
                <!-- END Portlet PORTLET-->
            </div>
    </div>
</sec:authorize>
<sec:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PENTEST_ADMIN')">
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="col-md-3 col-sm-12">
                <div class="small-box bg-primary">
                    <div class="inner">
                        <h3>${customersCount}</h3>
                        <p class=""><spring:message code="dashboard.customersCount"/></p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-cubes"></i>
                    </div>
                    <a href="../admin/listCustomers.htm" class="small-box-footer"><spring:message code="dashboard.listCustomers"/>&nbsp;<i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
    </div>
</sec:authorize>
<!---------------------------------------- ÖNE ÇIKAN VARLIKLAR VE ÖNE ÇIKAN ZAFİYETLER ---------------------------------------->

<sec:authorize access="hasAnyRole('ROLE_COMPANY_MANAGER, ROLE_COMPANY_MANAGER_READONLY')">
    <div class="row">
        <div class="col-lg-4" style="padding-right: 3px;">
            <div class="portlet light dark-index bordered shadow-soft" style="height:580px;" >
                <div class="portlet-title portlet-title-black" >
                    <div class="caption">
                        <span class="caption-subject font-dark bold uppercase"><spring:message code="dashboard.featuredAssets"/></span>

                    </div>
                    <div style="display:flex; justify-content: flex-end;">
                        <div class="bizzy-help-tip" style="position: relative; top: 1px; margin-right: 5px;" ><i class="fas fa-info-circle" style="color: #e9ecf3;"></i>
                            <p><spring:message code="tooltip.featuredAssetsGraph"/></p>
                        </div>
                        <a class="btn btn-xs white btn-outline btn-circle" id="showAll1" style="float: right;" onclick="showAllAsset()"><spring:message code="dashboard.showAll"/></a>
                    </div>
                </div>
                <table class="table table-striped table-bordered table-hover" id="top10AssetTable" style="table-layout:fixed; width: 100% !important;" >
                    <thead>
                        <tr>
                            <th style="vertical-align: middle; min-width: 55px; min-height: 42px;" width="55px" heigth="42px"><spring:message code="dashboard.riskScoreName"/></th>
                            <th style="vertical-align: middle; min-width: 120px; min-height: 42px;" width="170px" heigth="42px"><spring:message code="listAssets.asset"/></th>
                            <th style="vertical-align: middle; min-width: 120px; min-height: 42px;" width="120px" heigth="42px"><spring:message code="dashboard.totalDangerousVuln"/></th>
                        </tr>
                    </thead>
                </table>                        
            </div>
        </div>
        <div class="col-lg-4" style="padding-left: 3px !important; padding-right: 3px !important;">
            <div class="portlet light dark-index bordered shadow-soft" style="height:580px;">
                <div class="portlet-title portlet-title-black">
                    <div class="caption">
                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.topTenWebAppVuln"/></span>
                        <div class="bizzy-help-tip" style="right:10px;" ><i class="fas fa-info-circle" style="color: #e9ecf3;"></i>
                            <p>  <spring:message code="tooltip.topTenWebAppVulnGraph"/> </p>
                        </div>
                    </div>
                </div>
                <div class="portlet-body portlet-body-black" style="height:100%">
                     <div id="topTenWebAppVulnWait" style="height:170px;width:40%;margin-top: 270px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                        <div class="bounce1"></div>
                        <div class="bounce2"></div>
                        <div class="bounce3"></div>
                     </div>
                    <div id="topTenWebAppVuln" style="width: 100%; min-height: 98%;"></div>
                </div>
            </div>
        </div>
        <div class="col-lg-4" style="padding-left: 3px;">
            <div class="portlet light dark-index bordered shadow-soft" style="height:580px;">
                <div class="portlet-title portlet-title-black">
                    <div class="caption">
                        <span class="caption-subject font-dark bold uppercase"><spring:message code="dashboard.featuredVulnerabilities"/></span>

                    </div>
                    <div style="display:flex; justify-content: flex-end;">
                        <div class="bizzy-help-tip" style="position: relative; top: 1px; margin-right: 5px;" ><i class="fas fa-info-circle" style="color: #e9ecf3;"></i>
                            <p><spring:message code="tooltip.featuredVulnerabilitiesGraph"/></p>
                        </div>
                        <a class="btn btn-xs white btn-outline btn-circle" id="showAll2" style="float: right;" onclick="showAllVulnerability()"><spring:message code="dashboard.showAll"/></a>
                    </div>
                </div>
                <table class="table table-striped table-bordered table-hover" id="top10VulnTable" style="table-layout:fixed; padding-left: 5px; padding-right: 6px; width: 100% !important;">
                    <thead>
                        <tr>
                            <th style="vertical-align: middle; min-width: 55px;" width="55px"><spring:message code="dashboard.riskScoreName"/></th>
                            <th style="vertical-align: middle; min-width: 200px;" width="200px"><spring:message code="listVulnerabilities.vName"/></th>
                            <th style="vertical-align: middle; min-width: 55px"><spring:message code="dashboard.assetsCount"/></th>
                            <th style="vertical-align: middle; min-width: 60px;"><spring:message code="dashboard.openClosedAsset"/></th>
                            <th style="vertical-align: middle; min-width: 45px;" width="45px"><spring:message code="listKBItems.riskLevel"/></th>
                        </tr>
                    </thead>
                </table>                   
            </div>
        </div>
    </div>

    <jsp:include page="../customer/include/viewAssetModal.jsp" />
</sec:authorize>
<!---------------------------------------- USER EKRANI ---------------------------------------->

<sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
    <sec:authorize access="!hasRole('ROLE_COMPANY_MANAGER_READONLY')">
        <div class="row" style="padding-left:15px;">
            <div class="bizzy-usercard white col-md-3 col-xs-12 col-sm-12 shadow-soft">
                <div class="row">
                    <div class="additional col-lg-4 col-md-4  col-xs-5 col-sm-5">
                        <div class="user-card">
                            <div class="level usercard-center" id="userLevel">
                            </div>
                            <div class="points usercard-center" id="userScore">
                            </div>
                            <div class="userLevelProgress" id="userLevelProgress">
                                <img id="profilephoto" src="${profilephoto}" style="position: absolute; padding: 10px; border-radius: 200px; width: 100%"></img>
                            </div>
                        </div>
                        <div class="more-info">
                            <div class="usercard-header" style="color:white; font-size: 14px;"><spring:message code="dashboard.badges"/> &nbsp</div>
                            <div class="main-wrapper" id="badgeContainer">

                            </div>
                            <div class="stats">
                                <div>

                                </div>
                                <div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="general col-lg-8 col-md-8 col-xs-7 col-sm-7">
                        <div style="position:absolute; top:20%;">
                            <c:choose>
                                <c:when test="${sessionScope.performanceScoreActive}">
                                    <c:if test="${not empty vprList}">
                                        <c:if test="${fn:length(vprList) gt 0}">
                                            <span style="font-size: 10px; font-weight: 600; margin-top: 100px;">
                                                <div style="float: left"><b><spring:message code="dashboard.vpr"/> &nbsp</b></div><br/>
                                                <c:forEach var="vpr" items="${vprList}">
                                                    <c:choose>
                                                        <c:when test="${vpr.type == '0'}">
                                                            <div  style="border-top: 25px solid #FB8E90; color: black; width: 90%; margin-top: 6px;" class="bizzy-riskScore"><p style="margin-top: -22.5px;"><spring:message code="dashboard.level5"/>: ${vpr.name}</p></div>
                                                        </c:when>
                                                        <c:when test="${vpr.type == '1'}">
                                                            <div  style="border-top: 25px solid #FBC48E; color: black; width: 90%; margin-top: 6px;" class="bizzy-riskScore"><p style="margin-top: -22.5px;"><spring:message code="dashboard.level4"/>: ${vpr.name}</p></div>
                                                        </c:when>
                                                        <c:when test="${vpr.type == '2'}">
                                                            <div  style="border-top: 25px solid #FDEBAA; color: black; width: 90%; margin-top: 6px;" class="bizzy-riskScore"><p style="margin-top: -22.5px;"><spring:message code="dashboard.level3"/>: ${vpr.name}</p></div>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                                <br><br>
                                            </span>
                                        </c:if>
                                    </c:if>                                     
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${not empty slaList}">
                                        <c:if test="${fn:length(slaList) gt 0}">
                                            <span style="font-size: 10px; font-weight: 600; margin-top: 100px;">
                                                <div style="float: left"><b><spring:message code="dashboard.sla"/> &nbsp</b></div><br/>
                                                <c:forEach var="sla" items="${slaList}">
                                                    <c:choose>
                                                        <c:when test="${sla.name == '5'}">
                                                            <div  style="border-top: 25px solid #F80812; width: 90%; margin-top: 6px;" class="bizzy-riskScore"><p style="margin-top: -22.5px;"><spring:message code="dashboard.level5"/>: ${sla.time} ${sla.date_name}</p></div>
                                                        </c:when>
                                                        <c:when test="${sla.name == '4'}">
                                                            <div  style="border-top: 25px solid #F88008; width: 90%; margin-top: 6px;" class="bizzy-riskScore"><p style="margin-top: -22.5px;"><spring:message code="dashboard.level4"/>: ${sla.time} ${sla.date_name}</p></div>
                                                        </c:when>
                                                        <c:when test="${sla.name == '3'}">
                                                            <div  style="border-top: 25px solid #F8C508; color: black; width: 90%; margin-top: 6px;" class="bizzy-riskScore"><p style="margin-top: -22.5px;"><spring:message code="dashboard.level3"/>: ${sla.time} ${sla.date_name}</p></div>
                                                        </c:when>
                                                        <c:when test="${sla.name == '2'}">
                                                            <div  style="border-top: 25px solid #FEFE60; color: black;  width: 90%; margin-top: 6px;" class="bizzy-riskScore"><p style="margin-top: -22.5px;"><spring:message code="dashboard.level2"/>: ${sla.time} ${sla.date_name}</p></div>
                                                        </c:when>
                                                        <c:when test="${sla.name == '1'}">
                                                            <div  style="border-top: 25px solid #F9FABB; color: black;  width: 90%; margin-top: 6px;"  class="bizzy-riskScore"><p style="margin-top: -22.5px;"><spring:message code="dashboard.level1"/>: ${sla.time} ${sla.date_name}</p></div>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                                <br><br>
                                            </span>
                                        </c:if>
                                    </c:if>                                    
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-5" style="padding-left: 1px !important; padding-right: 1px;">
                <div class="portlet light dark-index bordered shadow-soft" >
                    <div class="portlet-body portlet-body-black" style="height: 300px;">
                        <!--<nav class="bizzy-upanel-tabs">
                           <div class="bizzy-upanel-selector"></div>
                           <a href="#" class="active"><i class="fas fa-bug"></i><spring:message code="generic.vulnerabilities"/></a>
                           <a href="#"><i class="far fa-calendar"></i><spring:message code="main.theme.listTickets"/></a>
                       </nav>-->
                        <div class="progress" id="userTicketStatusBar"></div>
                        <div id="userTable-wrapper" style="margin-top:10px;">
                            <table class="table" id="userTable" style="table-layout:fixed; margin-top: 20px; padding-left: 5px; padding-right: 6px;">
                                <thead>
                                    <tr>
                                        <th style="padding-left: 10px;"><spring:message code="mailtemp.tName"/></th>
                                        <th style="padding-left: 10px;"><spring:message code="datatable.ticketStatus.languageText"/></th>
                                        <c:choose>
                                            <c:when test="${sessionScope.performanceScoreActive}">
                                        <th style="padding-left: 10px; min-width: 80px;"><spring:message code="viewVulnerability.vprScore"/></th>
                                            </c:when> 
                                            <c:otherwise>
                                        <th style="padding-left: 10px;"><spring:message code="datatable.ticketPriority.languageText"/></th>
                                            </c:otherwise>
                                        </c:choose>
                                        <th style="padding-left: 10px;"><spring:message code="datatable.assigneeDatatableText"/></th>
                                        <th style="padding-left: 10px;"><spring:message code="datatable.difTimeString"/></th>                                                 
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4" style="padding-left: 1px !important; padding-right: 15px;">
                <div class="portlet light dark-index bordered shadow-soft" >
                    <div class="portlet-body portlet-body-black" style="height: 300px;">
                        <div id="userPerformanceChartWait" style="height:170px;width:40%;margin-top: 230px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                        <div class="bounce1"></div>
                        <div class="bounce2"></div>
                        <div class="bounce3"></div>
                     </div>
                        <div id="userPerformanceChart" style="width: 100%; min-height: 98%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </sec:authorize>
</sec:authorize>

<!---------------------------------------- DASHBOARD TABLARI VE ALTINDAKİ GRAFİKLER ---------------------------------------->

<sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
    <div id="graphTabs" class="panel panel-default">
        <div class="tab">
            <div class="btn-group special" role="group" >
                <button id="assetsTabButton" class="tablinks active" onclick="openTab(event, 'assetsTab');openAssetsTab();"><spring:message code="main.theme.listAssets"/></button>
                <button id="riskMeterTabButton" class="tablinks" onclick="openTab(event, 'riskMeterTab');
                        openRiskMeterTab();"><spring:message code="dashboard.riskMeter"/></button>
                <button id="riskScoreTabButton" class="tablinks" onclick="openTab(event, 'riskScoreTab');
                        openRiskScoreTab();"><spring:message code="dashboard.riskScoreName"/></button>
                <button id="vulnerabilitiesTabButton" class="tablinks" onclick="openTab(event, 'vulnerabilitiesTab');
                        openVulnerabilitiesTab();"><spring:message code="generic.vulnerabilities"/></button>
                <button id="portsTabButton" class="tablinks" onclick="openTab(event, 'portsTab');openPortsTab();"><spring:message code="generic.ports"/></button>
                <button id="categoriesTabButton" class="tablinks" onclick="openTab(event, 'categoriesTab');
                        openCategoriesTab()"><spring:message code="listCategories.title"/></button>
                <button id="performanceTabButton" class="tablinks" onclick="openTab(event, 'performanceTab'); openPerformanceTab();"><spring:message code="dashboard.performance"/></button>
            </div>
        </div>
        <div class="panel-body">
            <div class="tab-content">

                <!---------------------------------------- VARLIKLAR TABI ---------------------------------------->

                <div class="tabcontent" id="assetsTab" style="display: block;">
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.highscoreassets"/></span>
                                        <!--   <div class="bizzy-help-tip" >
                                               <p> </p>
                                           </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div class="row" style="width: 100%;height: 400px">
                                        <div  class="col-md-4 col-sm-12 col-xs-12 bizzy-scrollbar graph-legend-wrapper"  id="assetScoreLegendWrapper">
                                            <div class="graph-legend" id="assetScoreLegend"></div>
                                        </div>
                                        <div id="mostRiskySystemsWait" style="height:170px;width:40%;margin-top: 150px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                        <div class="col-md-8 col-sm-12 col-xs-12 v-hr graph-area" id="assetScore" style="display:none"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="top10ipgraphWait">
                            <div class="portlet light dark-index bordered shadow-soft" >
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.top10VulnerableIp"/></span>
                                        <!--    <div class="bizzy-help-tip" >
                                                <p> </p>
                                            </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                   
                                        <div id="top10ipgraph" style="width: 100%;height: 400px"></div>
                                         <div id="top10weaknessWait" style="left: 50%; top: 42%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                  
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="assetriskWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.assetrisk"/></span>
                                        <!--   <div class="bizzy-help-tip" >ay
                                               <p> </p>
                                           </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="assetrisk" style="width: 100%;height: 400px"></div>
                                      <div id="accordingToRiskLevelsWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="assetgroupsvulnWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.assetgroupsvuln"/></span>
                                        <!--    <div class="bizzy-help-tip" >
                                                <p> </p>
                                            </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="assetgroupsvuln" style="width: 100%;height: 400px" ></div>
                                    <div id="accordingToAssetGroup" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                </div>

                <!---------------------------------------- RİSK METRE TABI ---------------------------------------->

                <div class="tabcontent" id="riskMeterTab">
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="btn-group" data-toggle="buttons" id="filters" style="float:right;margin-right:15px;margin-bottom:15px">
                            <label class="btn btn-primary active" for="options">
                                <input type="radio" name="options" id="option1" value="0" /> <spring:message code="DAILY"/>
                            </label>
                            <label class="btn btn-primary" for="options">
                                <input type="radio" name="options" id="option2" value="1" /> <spring:message code="MONTHLY"/>
                            </label>
                            <label class="btn btn-primary" for="options">
                                <input type="radio" name="options" id="option3" value="2" /> <spring:message code="dashboard.3months"/>
                            </label>
                            <label class="btn btn-primary" for="options">
                                <input type="radio" name="options" id="option4" value="3" /> <spring:message code="dashboard.6months"/>
                            </label>
                        </div>
                        <div class="col-lg-12">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.vulnDayGraph"/></span>
                                        <!--  <div class="bizzy-help-tip" >
                                              <p> </p>
                                          </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="vulnDayGraphWait" style="height:170px;width:40%;margin-top: 150px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                    <div id="vulnDayGraph"></div>
                                </div>
                            </div>
                        </div>
                        

                        <div class="col-lg-12">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.vulnDayGraphStatus"/> </span>
                                        <!--  <div class="bizzy-help-tip" >
                                              <p> </p>
                                          </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="vulnDayGraphStatusWait" style="height:170px;width:40%;margin-top: 150px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                    <div id="vulnDayGraphStatus">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="DAILY"/> <spring:message code="dashboard.vulnDayGraph"/></span>
                                        <!--   <div class="bizzy-help-tip" >
                                               <p> </p>
                                           </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="heatMapWait" style="height:170px;width:40%;margin-top: 150px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                    <div id="heatMap"></div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                </div>

                <!---------------------------------------- RİSK SKORU TABI ---------------------------------------->

                <div class="tabcontent" id="riskScoreTab">
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-12">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.dailyRiskScore"/></span>
                                        <!--     <div class="bizzy-help-tip" >
                                                 <p> </p>
                                             </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="riskScoreWait" style="height:170px;width:40%;margin-top: 150px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                    <div id="riskScoreGraph">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-12">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.dailyRiskScoreByLevel"/></span>
                                        <!--   <div class="bizzy-help-tip" >
                                               <p> </p>
                                           </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="riskScoreByLevelWait" style="height:170px;width:40%;margin-top: 150px;display: block;margin-left:auto;margin-right:auto" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                    <div id="riskScoreGraphByLevel"></div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                </div>

                <!---------------------------------------- ZAFİYETLER TABI ---------------------------------------->

                <div class="tabcontent" id="vulnerabilitiesTab">
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="riskLevelVulnGraphWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.riskLevelVulnGraph"/></span>
                                        <!--       <div class="bizzy-help-tip" >
                                                   <p> </p>
                                               </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="riskLevelVulnGraph" style="width: 100%;height: 400px"></div>
                                      <div id="vulnerabilitiesByRiskLevelsWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="effectgraphWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.effectvulnerabilities"/></span>
                                        <!--    <div class="bizzy-help-tip" >
                                                <p> </p>
                                            </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div class="flot-chart">
                                        <div id="effectgraph" style="width: 100%;height: 400px"></div>
                                         <div id="weaknessByImpactWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="top10kbgraphWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i><spring:message code="dashboard.top10Vulnerabilities"/></span>
                                        <!--  <div class="bizzy-help-tip" >
                                              <p> </p>
                                          </div> !-->
                                    </div>
                                </div> 
                                <div class="portlet-body portlet-body-black">
                                    <div class="flot-chart">
                                        <div id="top10kbgraph" style="width: 100%;height: 400px"></div>
                                         <div id="top10VulnerabilitiesWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="rootcausegraphWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i>  <spring:message code="dashboard.rootvulnerabilities"/></span>
                                        <!--  <div class="bizzy-help-tip" >
                                              <p> </p>
                                          </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div class="flot-chart">
                                        <div id="rootcausegraph" style="width: 100%;height: 400px"></div>
                                         <div id="rootCauseGraphWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="cvegraphWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.cveDisribution"/></span>
                                        <!--    <div class="bizzy-help-tip" >
                                                <p> </p>
                                            </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div class="flot-chart">
                                        <div id="cvegraph" style="width: 100%;height: 400px"></div>
                                         <div id="cveDisributionWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                </div>

                <!---------------------------------------- PORTLAR TABI ---------------------------------------->

                <div class="tabcontent" id="portsTab">
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="portgraphWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.vulnerabilitiesbyport"/></span>
                                        <!--    <div class="bizzy-help-tip" >
                                                <p> </p>
                                            </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="portgraph" style="width: 100%;height: 400px"></div>
                                       <div id="accordingToPortWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                </div>
                            </div>
                        </div>
                    
                    <div class="col-lg-6" id="portservicesWait">
                        <div class="portlet light dark-index bordered shadow-soft">
                            <div class="portlet-title portlet-title-black">
                                <div class="caption">
                                    <i class="icon-equalizer font-dark hide"></i>
                                    <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.portservices"/></span>
                                    <!--    <div class="bizzy-help-tip" >
                                            <p> </p>
                                        </div> !-->
                                </div>
                            </div>
                            <div class="portlet-body portlet-body-black">
                                <div class="row" style="width: 100%;height: 400px">
                                    <div  class="col-md-4 col-sm-12 col-xs-12 bizzy-scrollbar graph-legend-wrapper"  id="portservicesLegendWrapper">
                                        <div class="graph-legend" id="portservicesLegend"></div>
                                    </div>
                                     <div id="accordingToPortServiceWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                    
                                    <div class="col-md-8 col-sm-12 col-xs-12 v-hr graph-area" id="portservices"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6" id="operatingsystemsWait">
                        <div class="portlet light dark-index bordered shadow-soft">
                            <div class="portlet-title portlet-title-black">
                                <div class="caption">
                                    <i class="icon-equalizer font-dark hide"></i>
                                    <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.countAssetsByOS"/></span>
                                    <!--      <div class="bizzy-help-tip" >
                                              <p> </p>
                                          </div> !-->
                                </div>
                                <div class="btn-group" data-toggle="buttons" id="filters" style="float:right;">
                                    <label class="btn btn-xs white btn-outline btn-circle active" for="osoptions">
                                        <input type="radio" name="osoptions" id="osoption1" value="0" /><spring:message code="dashboard.detailed"/>
                                    </label>
                                    <label class="btn btn-xs white btn-outline btn-circle " for="osoptions">
                                        <input type="radio" name="osoptions" id="osoption2" value="1" /><spring:message code="dashboard.general"/>
                                    </label>
                                </div>
                            </div>

                            <div class="portlet-body portlet-body-black">
                                <div class="row">
                                    <div  class="col-md-4 col-sm-12 col-xs-12 bizzy-scrollbar graph-legend-wrapper"  id="legendwrapper">
                                        <div class="graph-legend" id="operatingSystemsLegend"></div>
                                    </div>
                                    <div id="accordingToOperatingSystemsWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                    
                                    <div class="col-md-8 col-sm-12 col-xs-12 v-hr graph-area" id="operatingsystems"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6" id="assetsbyassetgroupWait">
                        <div class="portlet light dark-index bordered shadow-soft">
                            <div class="portlet-title portlet-title-black">
                                <div class="caption">
                                    <i class="icon-equalizer font-dark hide"></i>
                                    <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.countAssetsByAssetGroup"/></span>
                                    <!--     <div class="bizzy-help-tip" >
                                             <p> </p>
                                         </div> !-->
                                </div>
                            </div>
                            <div class="portlet-body portlet-body-black">
                                <div class="row" style="width: 100%;height: 400px">
                                    <div  class="col-md-4 col-sm-12 col-xs-12 bizzy-scrollbar graph-legend-wrapper"  id="assetsbyassetgroupLegendWrapper">
                                        <div class="graph-legend" id="assetsbyassetgroupLegend"></div>
                                    </div>
                                    <div id="accordingToAssetsGroupCountWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                        </div>
                                    
                                    <div class="col-md-8 col-sm-12 col-xs-12 v-hr graph-area" id="assetsbyassetgroup"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </sec:authorize>
                </div>

                <!---------------------------------------- ZAFİYET KATEGORİLERİ TABI ---------------------------------------->

                <div class="tabcontent" id="categoriesTab">
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="categorygraphWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.categoryvulnerabilities"/></span>
                                        <!--        <div class="bizzy-help-tip" >
                                                    <p> </p>
                                                </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="categorygraph" style="width: 100%;height: 400px"></div>
 				    <div id="accordingToCategoryWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-6" id="problemvulnerabilitiesWait">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.problemvulnerabilities"/></span>
                                        <!--   <div class="bizzy-help-tip" >
                                               <p> </p>
                                           </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div class="row" style="width: 100%;height: 400px">
                                        <div  class="col-md-4 col-sm-12 col-xs-12 bizzy-scrollbar graph-legend-wrapper"  id="problemvulnerabilitiesLegendWrapper">
                                            <div class="graph-legend" id="problemvulnerabilitiesLegend"></div>
                                        </div>

					<div id="accordingToProblemAreaWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                         <div class="bounce1"></div>
                                         <div class="bounce2"></div>
                                         <div class="bounce3"></div>
                                        </div>
                                        <div class="col-md-8 col-sm-12 col-xs-12 v-hr graph-area" id="problemvulnerabilities"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                    <div class="col-lg-12">
                        <div class="portlet light dark-index bordered shadow-soft" >
                            <div class="portlet-title portlet-title-black">
                                <div class="caption">
                                    <i class="icon-equalizer font-dark hide"></i>
                                    <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.riskVuln"/></span>
                                    <!--   <div class="bizzy-help-tip" >
                                           <p> </p>
                                       </div> !-->
                                </div>
                            </div>
                            <div class="portlet-body portlet-body-black">
                                <table width="100%" class="table table-striped table-bordered table-hover" id="serverDatatables" >
                                    <thead>
                                        <tr>
                                            <th style="vertical-align: middle;"><spring:message code="dashboard.riskCat"/></th>
                                            <th style="vertical-align: middle;"><spring:message code="dashboard.level5"/></th>
                                            <th style="vertical-align: middle;"><spring:message code="dashboard.level4"/></th>
                                            <th style="vertical-align: middle;"><spring:message code="dashboard.level3"/></th>
                                            <th style="vertical-align: middle;"><spring:message code="dashboard.level2"/></th>
                                            <th style="vertical-align: middle;"><spring:message code="dashboard.level1"/></th>
                                            <th style="vertical-align: middle;"><spring:message code="dashboard.total"/></th>
                                        </tr>
                                    </thead>
                                </table>

			     
                            </div>
                        </div>
                    </div>
                    </sec:authorize>
                </div>
                                        

                <!---------------------------------------- PERFORMANS TABI ---------------------------------------->

                <div class="tabcontent" id="performanceTab">
                    <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                        <div class="col-lg-12">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i><spring:message code="index.ocVulnGraphByLevel"/></span>
                                        <!--   <div class="bizzy-help-tip" >
                                               <p> </p>
                                           </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="levelOpenClosedCountGraph" style="width: 100%;height: 400px" ></div>
                                     <div id="levelOpenClosedCountGraphWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                          <div class="col-lg-6">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.timevulnerabilities"/></span>
                                        <!--    <div class="bizzy-help-tip" >
                                                <p> </p>
                                            </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="timegraph" style="width: 100%;height: 400px"></div>
                                     <div id="timegraphWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.vulnerabilitiesByTimeCumulative"/></span>
                                        <!--    <div class="bizzy-help-tip" >
                                                <p> </p>
                                            </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="totaltimegraph" style="width: 100%;height: 400px" ></div>
                                    <div id="totaltimegraphWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.manualAddedVulnerabilityByUserCumulative"/></span>
                                        <!--      <div class="bizzy-help-tip" >
                                                  <p> </p>
                                              </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="totalManualAddedVulGraph" style="width: 100%;height: 400px" ></div>
                                     <div id="totalManualAddedVulGraphWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="portlet light dark-index bordered shadow-soft">
                                <div class="portlet-title portlet-title-black">
                                    <div class="caption">
                                        <i class="icon-equalizer font-dark hide"></i>
                                        <span class="caption-subject font-dark bold uppercase"><i class="far fa-chart-bar"></i> <spring:message code="dashboard.userAssignedOpenVulnCount"/></span>
                                        <!--      <div class="bizzy-help-tip" >
                                                  <p> </p>
                                              </div> !-->
                                    </div>
                                </div>
                                <div class="portlet-body portlet-body-black">
                                    <div id="numberOfOpenVulnerabilitiesOnUserGraph" style="width: 100%;height: 400px" ></div>
                                     <div id="numberOfOpenVulnerabilitiesOnUserGraphWait" style="left: 50%; top: 45%;  position: absolute;  margin: 0; margin-right: -50%; margin-left: -5%;" class="center bizzy-spinner">
                                        <div class="bounce1"></div>
                                        <div class="bounce2"></div>
                                        <div class="bounce3"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </sec:authorize>
                </div>
            </div>
        </div>
    </div>
                
         <style>
        @keyframes blink {50% { color: transparent }}
        .loader__dot { animation: 1s blink infinite }
        .loader__dot:nth-child(2) { animation-delay: 250ms }
        .loader__dot:nth-child(3) { animation-delay: 500ms }
            
        </style>
</sec:authorize>
</body>
</html>

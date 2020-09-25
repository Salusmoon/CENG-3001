<%-- 
    Document   : customer
    Created on : 16.Eyl.2015, 15:19:21
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><spring:message code="generic.bizzy"/></title>
    </head>
    <body>
     
        <script type="text/javascript">
            var topTenIp,riskLevelGraph;
            var colorSet = new am4core.ColorSet();
            colorSet.list = ["#AADBF9", "#F9FABB", "#FEFE60", "#F8C508", "#F88008", "#F80812"].map(function (color) {
                return new am4core.color(color);
            });
            var vulnCountsByRiskLevel = ${vulnCountsByRiskLevel};
            am4core.ready(function() {
                am4core.useTheme(am4themes_animated);

                riskLevelGraph = am4core.create("pieChart", am4charts.PieChart);

               
                // Set inner radius
                riskLevelGraph.innerRadius = am4core.percent(50);

                // Add and configure Series
                var pieSeries = riskLevelGraph.series.push(new am4charts.PieSeries());
                pieSeries.colors = colorSet;
                pieSeries.dataFields.value = "value";
                pieSeries.dataFields.category = "label";
                pieSeries.slices.template.stroke = am4core.color("#fff");
                pieSeries.slices.template.strokeWidth = 2;
                pieSeries.slices.template.strokeOpacity = 1;
                
                // This creates initial animation
                pieSeries.hiddenState.properties.opacity = 1;
                pieSeries.hiddenState.properties.endAngle = -90;
                pieSeries.hiddenState.properties.startAngle = -90;
                
                topTenIp = am4core.create("chartdiv", am4charts.XYChart3D);
                

                // Create axes
                var categoryAxis = topTenIp.yAxes.push(new am4charts.CategoryAxis());
                categoryAxis.dataFields.category = "year";
                categoryAxis.numberFormatter.numberFormat = "#";
                categoryAxis.renderer.inversed = true;

                var  valueAxis = topTenIp.xAxes.push(new am4charts.ValueAxis()); 

                // Create series
                var series = topTenIp.series.push(new am4charts.ColumnSeries3D());
                series.dataFields.valueX = "count";
                series.dataFields.categoryY = "ip";
                series.name = "IP";
                series.columns.template.propertyFields.fill = "color";
                series.columns.template.tooltipText = "{valueX}";
                series.columns.template.column3D.stroke = am4core.color("#fff");
                series.columns.template.column3D.strokeOpacity = 0.2;
                
                 // Add data
                riskLevelGraph.data = [
                        {label: "<spring:message code="risk.level.0"/>", value: vulnCountsByRiskLevel[0]},
                        {label: "<spring:message code="risk.level.1"/>", value: vulnCountsByRiskLevel[1]},
                        {label: "<spring:message code="risk.level.2"/>", value: vulnCountsByRiskLevel[2]},
                        {label: "<spring:message code="risk.level.3"/>", value: vulnCountsByRiskLevel[3]},
                        {label: "<spring:message code="risk.level.4"/>", value: vulnCountsByRiskLevel[4]},
                        {label: "<spring:message code="risk.level.5"/>", value: vulnCountsByRiskLevel[5]}
                    ];
                topTenIp.data =  [
                <c:forEach varStatus="index" var="asset" items="${assetList}">
                    <c:if test="${index.index != 0}">
                        ,
                    </c:if>
                        {
                        ip: "<c:out value="${asset.ip}"/>", count: <c:out value="${asset.vulnerabilityCount}"/>
                        }
                </c:forEach>
                ];    
               
            }); // end am4core.ready()
            </script>

           
        </script>
        <div class="row">
            <div class="col-lg-12">
                <h3 class="page-title"><spring:message code="main.theme.dashboard"/></h3>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <spring:message code="${error}"></spring:message>
                </div>
        </c:if>
        <div class="row">
            <sec:authorize access="hasAnyRole('ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                <div class="col-lg-3 col-md-6">
                    <!-- BEGIN WIDGET THUMB -->
                    <div class="widget-thumb widget-bg-color-white text-uppercase margin-bottom-20 bordered shadow-soft">
                        <h4 class="widget-thumb-heading"><spring:message code="dashboard.assetsCount"/></h4>
                        <div class="widget-thumb-wrap">
                            <i class="widget-thumb-icon bg-yellow"> <i class="fas fa-cubes"></i> </i>
                            <div class="widget-thumb-body">
                                <span class="widget-thumb-body-stat" data-counter="counterup" data-value="${assetsCount}">${assetsCount}</span>
                                <span class="widget-thumb-subtitle">
                                    <div style="text-transform: none !important;">
                                        <a href="../customer/listAssets.htm">
                                            <span class="pull-left" style="color:#337ab7"><spring:message code="dashboard.listAssets"/></span>
                                        </a>
                                    </div>
                                </span>
                            </div>
                        </div>
                    </div>
                    <!-- END WIDGET THUMB -->
                </div>
            </sec:authorize>
            <sec:authorize access="hasAnyRole('ROLE_PENTEST_USER, ROLE_COMPANY_USER, ROLE_COMPANY_USER_AUTHORIZED')">
                <div class="col-lg-3 col-md-6">
                    <!-- BEGIN WIDGET THUMB -->
                    <div class="widget-thumb widget-bg-color-white text-uppercase margin-bottom-20 bordered shadow-soft">
                        <h4 class="widget-thumb-heading"><spring:message code="dashboard.categoriesCount"/></h4>
                        <div class="widget-thumb-wrap">
                            <i class="widget-thumb-icon bg-primary"> <i class="fas fa-tasks"></i> </i>
                            <div class="widget-thumb-body">
                                <span class="widget-thumb-body-stat" data-counter="counterup" data-value="${categoriesCount}">${categoriesCount}</span>
                                <span class="widget-thumb-subtitle">
                                    <div style="text-transform: none !important;">
                                        <a href="../kb/listCategories.htm">
                                            <span class="pull-left" style="color:#337ab7"><spring:message code="dashboard.listCategories"/></span>
                                        </a>
                                    </div>
                                </span>
                            </div>
                        </div>
                    </div>
                    <!-- END WIDGET THUMB -->
                </div>
                <div class="col-lg-3 col-md-6">
                    <!-- BEGIN WIDGET THUMB -->
                    <div class="widget-thumb widget-bg-color-white text-uppercase margin-bottom-20 bordered shadow-soft">
                        <h4 class="widget-thumb-heading"><spring:message code="dashboard.kbItemsCount"/></h4>
                        <div class="widget-thumb-wrap">
                            <i class="widget-thumb-icon bg-green"> <i class="fas fa-archive"></i> </i>
                            <div class="widget-thumb-body">
                                <span class="widget-thumb-body-stat" data-counter="counterup" data-value="${kbItemsCount}">${kbItemsCount}</span>
                                <span class="widget-thumb-subtitle">
                                    <div style="text-transform: none !important;">
                                        <a href="../kb/listKBItems.htm">
                                            <span class="pull-left" style="color:#337ab7"><spring:message code="dashboard.listKBItems"/></span>
                                        </a>
                                    </div>
                                </span>
                            </div>
                        </div>
                    </div>
                    <!-- END WIDGET THUMB -->
                </div>            
            </sec:authorize>
        </div>
        <div class="row">
            <div class="col-lg-6">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"> <i class="far fa-chart-bar"></i> <spring:message code="dashboard.top10VulnerableIp"/></span>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div id="chartdiv"></div>
                    </div>
                    <!-- /.panel-body -->
                </div>
            </div>
            <div class="col-lg-6">
                <div class="portlet light bordered shadow-soft">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="icon-equalizer font-dark hide"></i>
                            <span class="caption-subject font-dark bold uppercase"> <i class="far fa-chart-bar"></i> <spring:message code="dashboard.riskLevelVulnGraph"/></span>
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div id="pieChart"></div>               
                    </div>
                    <!-- /.panel-body -->
                </div>
            </div>

        </div>
        <div class="row">
            <div class="col-lg-6">
                <div>
                    <div class="portlet light bordered shadow-soft">
                        <div class="portlet-title">
                            <div class="caption">
                                <i class="icon-equalizer font-dark hide"></i>
                                <span class="caption-subject font-dark bold uppercase"> <spring:message code="dashboard.top10Vulnerabilities"/></span>
                            </div>
                        </div>
                        <div class="portlet-body">
                            <table class="table table-bordered table-hover table-striped">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th><spring:message code="vulnerability.name"/></th>
                                        <th><spring:message code="vulnerability.riskLevel"/></th>                                
                                        <th><spring:message code="vulnerability.count"/></th>                        
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach varStatus="status" var="topKBItem" items="${topKBItems}">
                                        <tr class="warning">
                                            <td>
                                                <c:out value="${status.index + 1}"/>
                                            </td>
                                            <td>
                                                <c:out value="${topKBItem.kbItemDescription.name}"/>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <table width="100%">
                                                        <tr>
                                                            <c:choose>
                                                                <c:when test="${topKBItem.riskLevel == 0}">
                                                                    <td style="vertical-align:middle;">
                                                                        <div class="riskLevel0 riskLevelCommon">
                                                                            <p>                                       
                                                                                <c:out value="${topKBItem.riskLevel}"/>                                       
                                                                            </p>
                                                                        </div>
                                                                    </td>
                                                                </c:when>
                                                                <c:when test="${topKBItem.riskLevel == 1}">
                                                                    <td style="vertical-align:middle;">
                                                                        <div class="riskLevel1 riskLevelCommon">
                                                                            <p>                                       
                                                                                <c:out value="${topKBItem.riskLevel}"/>                                       
                                                                            </p>
                                                                        </div>
                                                                    </td>
                                                                </c:when>
                                                                <c:when test="${topKBItem.riskLevel == 2}">
                                                                    <td style="vertical-align:middle;">
                                                                        <div class="riskLevel2 riskLevelCommon">
                                                                            <p>                                       
                                                                                <c:out value="${topKBItem.riskLevel}"/>                                       
                                                                            </p>
                                                                        </div>
                                                                    </td>
                                                                </c:when>
                                                                <c:when test="${topKBItem.riskLevel == 3}">
                                                                    <td style="vertical-align:middle;">
                                                                        <div class="riskLevel3 riskLevelCommon">
                                                                            <p>                                       
                                                                                <c:out value="${topKBItem.riskLevel}"/>                                       
                                                                            </p>
                                                                        </div>
                                                                    </td>
                                                                </c:when>
                                                                <c:when test="${topKBItem.riskLevel == 4}">
                                                                    <td style="vertical-align:middle;">
                                                                        <div class="riskLevel4 riskLevelCommon">
                                                                            <p>                                       
                                                                                <c:out value="${topKBItem.riskLevel}"/>                                       
                                                                            </p>
                                                                        </div>
                                                                    </td>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <td style="vertical-align:middle;">
                                                                        <div class="riskLevel5 riskLevelCommon">
                                                                            <p>                                       
                                                                                <c:out value="${topKBItem.riskLevel}"/>                                       
                                                                            </p>
                                                                        </div>
                                                                    </td>
                                                                </c:otherwise>
                                                            </c:choose>                                          
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <td>
                                                <c:out value="${topKBItem.countEncountered}"/>
                                            </td>
                                        </tr>
                                    </c:forEach>                    
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>            
            </div>
            <div class="col-lg-6">

            </div>
        </div>

        <!-- /.row -->
    </body>
</html>

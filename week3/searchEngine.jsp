<%-- 
    Document   : searchEngine
    Created on : 06-Aug-2018, 09:51:36
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/escapeUtil" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><spring:message code="generic.bizzy"/></title>
    </head>
    <body>
        <div class="row">
            <div class="col-lg-12">
                <ul class="page-breadcrumb breadcrumb"> <li>
                        <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                        <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                    </li>
                    <li>
                        <span class="title2"><spring:message code="main.theme.searchEngine"/></span>
                    </li>
                </ul>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="portlet light bordered shadow-soft">                    
                    <!-- /.panel-heading -->
                    <div class="col-lg-12" style="padding-bottom: 10px;">
                        <div class="alert alert-success"><spring:message code="searchEngine.info"/></div>
                        <div class="input-group input-group-lg">
                            <input type="text" id="txtSearch" class="form-control" placeholder="<spring:message code="searchEngine.placeholder"/>">
                            <span class="input-group-btn">
                                <button class="btn green" type="button" id="btnSearch"><spring:message code="generic.search"/></button>
                            </span>
                        </div>
                    </div>
                    <div class="col-lg-12" style="padding-bottom: 10px;">
                        <input type="radio" name="source" id="source" value="0" checked="checked"> <spring:message code="searchEngine.all"/>
                        <input type="radio" name="source" id="source" value="1"> <spring:message code="searchEngine.kb"/>
                        <input type="radio" name="source" id="source" value="2"> <spring:message code="searchEngine.nvd"/> 
                    </div>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <spring:message code="${error}"></spring:message>
                            </div>
                    </c:if>
                    <div class="portlet-body">
                        <div>
                            <table class="table table-striped table-bordered table-hover" id="serverDatatables" style="visibility: hidden; width:100% !important; ">
                                <thead>
                                    <tr> 
                                        <th style="vertical-align: middle; min-width: 30px;"><spring:message code="searchEngine.type"/></th>
                                        <th style="vertical-align: middle; min-width: 100px;"><spring:message code="addVulnerability.cveId"/></th>
                                        <th style="vertical-align: middle; min-width: 250px;"><spring:message code="addVulnerability.name"/></th> 
                                        <th style="vertical-align: middle; min-width: 100px;"><spring:message code="searchEngine.cvss"/></th>
                                        <th style="vertical-align: middle; min-width: 130px;"><spring:message code="listPorts.creationDate"/></th>
                                        <th style="vertical-align: middle; min-width: 150px;"><spring:message code="viewVulnerability.labels"/></th>  

                                    </tr>
                                </thead>                                
                            </table>                                                    
                        </div>                          
                    </div>
                    <!-- /.panel-body -->
                </div>
                <!-- /.panel -->
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->  

        <script type="text/javascript">
            document.title = "<spring:message code="main.theme.searchEngine"/> - BIZZY";
            
            $('#txtSearch').keypress(function (e) {
                if (e.which === 13) {
                    if ($("#txtSearch").val() !== '') {
                        getResults();
                    }
                return false;
            }
        });
            
            var oTable;
            $("#btnSearch").click(function () {
                if ($("#txtSearch").val() === '') {
                    $("#alertModalBody").empty();
                    $("#alertModalBody").html("<spring:message code="searchEngine.insertData"/>");
                    $("#alertModal").modal("show");
                } else {
                    getResults();
                }

            });

            function getResults() {
                if (oTable !== undefined) {
                    oTable.api().ajax.reload();
                } else {
                    document.getElementById("serverDatatables").style.visibility = "visible";
                    $(document).ready(function () {
                        oTable = $('#serverDatatables').dataTable({
                            "lengthMenu": [[25, 50, 100, 250], [25, 50, 100, 250]],
                            "processing": true,
                            "serverSide": true,
                            "bFilter": false,
                            "autoWidth": true,
                            "scrollX": true,
                            "language": {
                                "emptyTable": decodeHtml("<spring:message code="generic.emptyTable"/>"),
                                "processing": "<spring:message code="generic.tableLoading"/>",
                                "search": "<spring:message code="generic.search"/>  ",
                                "paginate": {
                                    "next": "<spring:message code="generic.next"/>",
                                    "previous": "<spring:message code="generic.back"/>"
                                },
                                "info": "<spring:message code="generic.tableInfo" arguments="${'_TOTAL_'},${'_START_'},${'_END_'}"/>",
                                "lengthMenu": '<spring:message code="generic.tableLength" arguments="${'_MENU_'}"/>',
                                "infoEmpty":  "<spring:message code="generic.tableInfo" arguments="${'0'},${'0'},${'0'}"/>"
                            },
                            "columns": [
                                {"data": 'type',
                                    "render": function (data) {
                                        var context = '${pageContext.request.contextPath}';
                                        if (data === 'nvd') {
                                            return '<img src=\"' + context + '/resources/logo/NVD-logo-carousel.png\" alt=\"NVD-logo-carousel.png\" style=\"width: 50px;\">';
                                        } else {
                                            return '<img src=\"' + context + '/resources/logo/bizzy_logo.png\" alt=\"bizzy_logo.gif\" style=\"width: 50px;\">';
                                        }
                                    },
                                    "searchable": false,
                                    "orderable": false
                                },
                                {"data": 'cveId',
                                    "render": function (data) {
                                        if (data === '' || data === null) {
                                            return '<i class="fas fa-minus"></i>';
                                        } else {
                                            return data;
                                        }
                                    },
                                    "searchable": false,
                                    "orderable": false
                                },
                                {"data": 'name',
                                    "render": function (data) {
                                        if (data === '' || data === null) {
                                            return '<i class="fas fa-minus"></i>';
                                        } else {
                                            return data;
                                        }
                                    },
                                    "searchable": false,
                                    "orderable": false
                                },
                                {"data": 'cvssScore',
                                    "render": function (data) {
                            if (data === '' || data === null) {
                                return '<div class="riskLevel0 bold riskLevelCommon">' + "-" + '</div>';
                            } else {
                                var value = parseFloat(data);
                                if ( value >= 0 && value < 2){
                                    return '<div class="riskLevel1 bold riskLevelCommon">' + data + '</div>';
                                } else if ( value >= 2 && value < 4){
                                    return '<div class="riskLevel2 bold riskLevelCommon">' + data + '</div>';
                                } else if ( value >= 4 && value < 6){
                                    return '<div class="riskLevel3 bold riskLevelCommon">' + data + '</div>';
                                } else if ( value >= 6 && value < 8){
                                    return '<div class="riskLevel4 bold riskLevelCommon">' + data + '</div>';
                                } else if ( value >= 8 && value <= 10){
                                    return '<div class="riskLevel5 bold riskLevelCommon">' + data + '</div>';
                                } else {
                                    return '<div class="riskLevel0 bold riskLevelCommon">' + "-" + '</div>';
                                }
                            }
                                    },
                                    "searchable": false,
                                    "orderable": false
                                },
                                {"data": 'createDate', "searchable": false, "orderable": false},
                                {"data": 'keywords',
                                    "render": function (data) {
                                        if (data === '' || data === null) {
                                            return '<i class="fas fa-minus"></i>';
                                        } else {
                                            return data;
                                        }
                                    },
                                    "searchable": false,
                                    "orderable": false
                                }
                            ],
                            "ajax": {
                                "type": "POST",
                                "url": "loadEngineResults.json",
                                "data": function (d) {
                                    d.${_csrf.parameterName} = "${_csrf.token}";
                                    d.txtSearch = $("#txtSearch").val();
                                    d.source = $('input[name=source]:checked').val();
                                },
                                // error callback to handle error
                                "error": function (jqXHR, textStatus, errorThrown) {
                                    console.log("Datatables Ajax error!" + textStatus + " " + errorThrown);
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html("<spring:message code="listPorts.tableError"/>");
                                    $("#alertModal").modal("show");
                                }
                            }
                        });
                    });
                    $('#serverDatatables').on('click', 'tr', function () {
                        showModal(oTable.api().row(this).data());
                    });
                }
            }

            function showModal(id) {
                if (id.type === 'nvd') {
                    $.post("getEngineResult.json", {id: id.nvdVulnerabilityId, ${_csrf.parameterName}: "${_csrf.token}"}, function () {
                    }).done(function (data) {
                        var value = data;
                        if (value.cveId === null || value.cveId === '') {
                            document.getElementById("cveId").innerHTML = '<i class="fas fa-minus"></i>';
                        } else {
                            document.getElementById("cveId").innerHTML = '<a href=\"https://nvd.nist.gov/vuln/detail/' + value.cveId + '\" target=\"_blank\" >' + value.cveId + '</a>';
                        }

                        if (value.cvssScore === null) {
                            document.getElementById("cvss").innerHTML = '<i class="fas fa-minus"></i>';
                        } else {
                            var number = parseFloat(value.cvssScore);
                            if(number >= 0 && number < 1){
                                         document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge0.png"/>\n\
                      <br><br><b><div class="bold riskLevel0 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 1 && number < 2){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge1.png"/>\n\
                      <br><br><b><div class="bold riskLevel1 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 2 && number < 3){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge2.png"/>\n\
                      <br><br><b><div class="bold riskLevel1 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 3 && number < 4){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge3.png"/>\n\
                      <br><br><b><div class="bold riskLevel2 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 4 && number < 5){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge4.png"/>\n\
                      <br><br><b><div class="bold riskLevel2 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 5 && number < 6){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge5.png"/>\n\
                      <br><br><b><div class="bold riskLevel3 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 6 && number < 7){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge6.png"/>\n\
                      <br><br><b><div class="bold riskLevel3 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 7 && number < 8){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge7.png"/>\n\
                      <br><br><b><div class="bold riskLevel4 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 8 && number < 9){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge8.png"/>\n\
                      <br><br><b><div class="bold riskLevel4 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number >= 9 && number < 10){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge9.png"/>\n\
                      <br><br><b><div class="bold riskLevel5 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            } else if(number === 10){
                                           document.getElementById("cvss").innerHTML = '<img style="width:12vw" src = "${pageContext.request.contextPath}/resources/logo/gauge10.png"/>\n\
                      <br><br><b><div class="bold riskLevel5 riskLevelCommon" style="width:50%;display: block;margin-left: auto;margin-right: auto;">' + value.cvssScore + '</div></b>';
                            }
                            
                        }

                        if (value.keywords === '') {
                            document.getElementById("keywords").innerHTML = '<i class="fas fa-minus"></i>';
                        } else {
                            document.getElementById("keywords").innerHTML = value.keywords;
                        }

                        document.getElementById("createDate").innerHTML = moment(value.createDate).format("DD-MM-YYYY HH:mm:ss");

                        document.getElementById("vulnDescription").innerHTML = value.description;
                        $('#vulnModal').modal('show');
                    });
                } else {
                    window.open('viewKBItem.htm?kbItemId=' + id.nvdVulnerabilityId, '_blank');
                }

            }
        </script>
        <jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
        <div class="modal fade" id="vulnModal" tabindex="-1" role="dialog" aria-labelledby="myModal" aria-hidden="true"> 
            <div class="modal-dialog" style="height: 90%; overflow-x: hidden; width: 70%;"> 
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title"><spring:message code="viewQualysReport.details"/></h4>
                    </div>
                    <div id="modalBody">
                        <div id="detailVuln">
                            <div class="col-lg-12">
                            <div class="col-lg-8">
                                <table width="100%" class="table table-primary table-bordered table-hover" style="width: 100%; margin-top: 1%;">
                                    <tr>
                                        <th colspan="3"><b><spring:message code="addVulnerability.cveId"/></b></th>
                                    </tr> 
                                    <tr>
                                        <td colspan="3" id="cveId"></td>
                                    </tr>
                                    <tr>
                                        <th colspan="4"><spring:message code="listPorts.creationDate"/></th>
                                    </tr>
                                    <tr>
                                        <td colspan="4" id="createDate" ></td>
                                    </tr>
                                    <tr>
                                        <th colspan="4" id="labelsHeader"><spring:message code="viewVulnerability.labels"/></th>
                                    </tr>
                                    <tr>
                                        <td colspan="4" id="keywords"></td>
                                    </tr>
                                    <tr>
                                        <th colspan="4"><spring:message code="viewQualysReport.description"/></th>
                                    </tr>
                                    <tr>
                                        <td colspan="4" id="vulnDescription" ></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-lg-4">
                                <table width="100%" class="table table-primary table-bordered table-hover" style="width: 100%; margin-top: 2%;">
                                    <tr>
                                        <th width="20%" style="text-align: center"><spring:message code="searchEngine.cvss"/></th>
                                    </tr> 
                                    <tr>
                                        <td width="20%" style="text-align: center" id="cvss"></td>
                                    </tr>
                                </table>
                            </div>
                            </div>
                        </div>
                        <div class="modal-footer"> 
                            <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="generic.close"/></button> 
                        </div> 
                    </div> 
                </div> 
            </div>
        </div>  
    </body>
</html>


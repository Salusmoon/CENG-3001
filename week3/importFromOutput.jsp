<%-- 
    Document   : importFromOutput
    Created on : Apr 15, 2015, 9:51:37 AM
    Author     : adem.dilbaz
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><spring:message code="generic.bizzy"/></title>
</head>
<body>
    <style>
        
        .mt-element-step .step-line .mt-step-col{
            padding: 0px;
        }

        .mt-element-step .step-line .mt-step-title{
            font-size: 14px;
        }
        .form .form-actions, .portlet-form .form-actions{
            background-color : #1f1f1f;
            border-top: none;    
        }
        .portlet-title{
            padding-left : 20px !important;
        }
        .col-center-block {
            float: none;
            display: block;
            margin: 0 auto;
        }
        input.radio:empty {
            margin-left: -999px;
        }
        input.radio:empty ~ label {
            position: relative;
            float: left;
            line-height: 0.5em;
            text-indent: 3.25em;
            margin-top: 2em;
            cursor: pointer;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            opacity:0.3
        }
        .nav-pills>li.active>a, .nav-pills>li.active>a:focus, .nav-pills>li.active>a:hover{
            background-color: #dedede;
        }
        input.radio:empty ~ label:before {
            position: absolute;
            display: block;
            top: 0;
            bottom: 0;
            left: 0;
            content: '';
            width: 0.5em;
            background: #FFF;
            border-radius: 3px 0 0 3px;
        }
        input.radio:hover:not(:checked) ~ label:before {
            content:'';
            text-indent: .9em;
            color: #C2C2C2;
        }
        input.radio:hover:not(:checked) ~ label {
            color: #888;
        }
        input.radio:checked ~ label:before {
            content:'';
            text-indent: .9em;
            color: #9CE2AE;
            background-color: #2e353c;
        }
        input.radio:checked ~ label {
            color: #777;
            opacity:1.0
        }
        input.radio:focus ~ label:before {
            box-shadow: 0 0 0 3px #999;
        }
        
        .custom-file-upload {
            border: 1px solid #ccc;
            display: inline-block;
            width: 100%;
            padding: 6px 12px;
            cursor: pointer;
            font-size: 20px
        }
        .file-input-wrapper{
            display:none
        }
        .nav-tabs.wizard {
        background-color: transparent;
        padding: 0;
        width: 100%;
        margin: 1em auto;
        border-radius: .25em;
        clear: both;
        border-bottom: none;
      }

      .nav-tabs.wizard li {
        width: 100%;
        float: none;
        margin-bottom: 3px;
      }

      .nav-tabs.wizard li>* {
        position: relative;
        padding: 1em .8em .8em 2.5em;
        color: #999999;
        background-color: #dedede;
        border-color: #dedede;
      }

      .nav-tabs.wizard li.completed>* {
        color: #fff !important;
        background-color: #96c03d !important;
        border-color: #96c03d !important;
        border-bottom: none !important;
      }

      .nav-tabs.wizard li.active>* {
        color: #fff !important;
        background-color: #2c3f4c !important;
        border-color: #2c3f4c !important;
        border-bottom: none !important;
      }

      .nav-tabs.wizard li::after:last-child {
        border: none;
      }

      .nav-tabs.wizard > li > a {
        opacity: 1;
        font-size: 14px;
      }

      .nav-tabs.wizard a:hover {
        color: #fff;
        background-color: #2c3f4c;
        border-color: #2c3f4c
      }


      @media(min-width:992px) {
        .nav-tabs.wizard li {
          position: relative;
          margin-left: 100px;
          margin: 4px 4px 4px 0;
          width: 19.6%;
          float: left;
          text-align: center;
        }
        .nav-tabs.wizard li.active a {
          padding-top: 15px;
        }
        .nav-tabs.wizard li::after,
        .nav-tabs.wizard li>*::after {
          content: '';
          position: absolute;
          top: 1px;
          left: 100%;
          height: 0;
          width: 0;
          border: 45px solid transparent;
          border-right-width: 0;
          /*border-left-width: 20px*/
        }
        .nav-tabs.wizard li::after {
          z-index: 1;
          -webkit-transform: translateX(4px);
          -moz-transform: translateX(4px);
          -ms-transform: translateX(4px);
          -o-transform: translateX(4px);
          transform: translateX(4px);
          border-left-color: #fff;
          margin: 0
        }
        .nav-tabs.wizard li>*::after {
          z-index: 2;
          border-left-color: inherit
        }
        .nav-tabs.wizard > li:nth-of-type(1) > a {
          border-top-left-radius: 10px;
          border-bottom-left-radius: 10px;
        }
        .nav-tabs.wizard li:last-child a {
          border-top-right-radius: 10px;
          border-bottom-right-radius: 10px;
        }
        .nav-tabs.wizard li:last-child {
          margin-right: 0;
        }
        .nav-tabs.wizard li:last-child a:after,
        .nav-tabs.wizard li:last-child:after {
          content: "";
          border: none;
        }
        .nav>li>a:focus, .nav>li>a:hover{
          background-color: #dedede;
        }

        .form-wizard .steps, .form-wizard .steps>li>a.step{
          background-color: #dedede;
        }
        .nav-tabs>li>a{
          color: white;
        }

        .nav>li>a:focus, .nav>li>a:hover{
          background-color: #43474a;
        }
        .nav-tabs>li.active>a, .nav-tabs>li.active>a:focus, .nav-tabs>li.active>a:hover{
            color: white;
            background-color: #43474a;
        }
        .form-wizard .steps, .form-wizard .steps>li>a.step{
            background-color : #43474a;        
        }

        .form-wizard .steps>li.active>a.step .desc{
            color : #36c6d3 !important;
        }

        .form-wizard .steps>li>a.step .desc{
            color : white !important;
        }


    </style>

<script type="text/javascript" >
    document.title = "<spring:message code="importFromNessusOutput.importFromNessusOutput"/> - BIZZY";
    var FormWizard = function () {
        return {
            init: function () {
                if (!jQuery().bootstrapWizard) {
                    return;
                }
                var form = $('#submit_form');
                var error = $('.alert-danger', form);
                var success = $('.alert-success', form);

                form.validate({
                    doNotHideMessage: true,
                    focusInvalid: false,
                    rules: {
                        'radio': {
                            required: true
                        }
                    },
                    messages: {
                    },
                    errorPlacement: function (error, element) {

                    },
                    invalidHandler: function (event, validator) {
                        success.hide();
                        error.show();
                        App.scrollTo(error, -200);
                    },
                    highlight: function (element) {
                        $(element)
                                .closest('.form-group').removeClass('has-success').addClass('has-error');
                    },
                    unhighlight: function (element) {
                        $(element)
                                .closest('.form-group').removeClass('has-error');
                    },
                    success: function (label) {
                        if (label.attr("name") === "radio") {
                            label
                                    .closest('.form-group').removeClass('has-error').addClass('has-success');
                            label.remove();

                        } else {
                            label
                                    .addClass('valid')
                                    .closest('.form-group').removeClass('has-error').addClass('has-success');
                        }
                        $('#radio-error').css('display', 'none');
                    },
                    submitHandler: function (form) {

                        error.hide();
                        form.submit();
                    }
                });

                var displayConfirm = function () {
                    $('#tab4 .form-control-static', form).each(function () {
                        var input = $('[name="' + $(this).attr("data-display") + '"]', form);
                        if (input.is(":radio")) {
                            input = $('[name="' + $(this).attr("data-display") + '"]:checked', form);
                        }
                        if (input.is(":text") || input.is("textarea")) {
                            $(this).html(input.val());
                        } else if (input.is("select")) {
                            $(this).html(input.find('option:selected').text());
                        } else if (input.is(":radio") && input.is(":checked")) {
                            $(this).html(input.attr("data-title"));
                        } else if ($(this).attr("data-display") === 'payment[]') {
                            var payment = [];
                            $('[name="payment[]"]:checked', form).each(function () {
                                payment.push($(this).attr('data-title'));
                            });
                            $(this).html(payment.join("<br>"));
                        }
                    });
                };

                var handleTitle = function (tab, navigation, index) {
                    var total = navigation.find('li').length;
                    var current = index + 1;
                    $('.step-title', $('#form_wizard_1')).text('Step ' + (index + 1) + ' of ' + total);
                    jQuery('li', $('#form_wizard_1')).removeClass("completed");
                    var li_list = navigation.find('li');
                    for (var i = 0; i < index; i++) {
                        jQuery(li_list[i]).addClass("completed");
                    }
                    if (current === 2) {
                        if ($('input[name=radio]:checked')[0] !== undefined) {
                            if ($('input[name=radio]:checked')[0].id === "EXCEL") {
                                $('#excelWarning').css('display', 'block');
                            } else {
                                $('#excelWarning').css('display', 'none');
                            }
                        }
                    }
                    if (current === 1) {
                        $('#form_wizard_1').find('.button-previous').hide();
                    } else {
                        $('#form_wizard_1').find('.button-previous').show();
                    }
                    if (current >= total) {
                        $('#form_wizard_1').find('.button-next').hide();
                        $('#form_wizard_1').find('.button-submit').show();
                        displayConfirm();
                    } else {
                        $('#form_wizard_1').find('.button-next').show();
                        $('#form_wizard_1').find('.button-submit').hide();
                    }
                    App.scrollTo($('.page-title'));
                };
                $('#form_wizard_1').bootstrapWizard({
                    'nextSelector': '.button-next',
                    'previousSelector': '.button-previous',
                    onTabClick: function (tab, navigation, index, clickedIndex) {
                        return false;
                        success.hide();
                        error.hide();
                        if (form.valid() === false) {
                            return false;
                        }
                        handleTitle(tab, navigation, clickedIndex);
                    },
                    onNext: function (tab, navigation, index) {
                    var total = navigation.find('li').length;
                    var current = index + 1;
                    $('.step-title', $('#form_wizard_1')).text('Step ' + (index + 1) + ' of ' + total);
                    jQuery('li', $('#form_wizard_1')).removeClass("completed");
                    var li_list = navigation.find('li');
                    for (var i = 0; i < index; i++) {
                        jQuery(li_list[i]).addClass("completed");
                    }
                        success.hide();
                        error.hide();
                        if (form.valid() === false) {
                            $('#radio-error').text('<spring:message code="importFromOutput.selectScanType"/>');
                            $('#radio-error').css('display', 'block');
                            return false;
                        }
                        if (index === 2) {
                            var result = false;
                            var filename = $("#file").val();
                            if (filename !== undefined && filename !== '') {
                                var extension = filename.replace(/^.*\./, '');
                                if (extension === filename) {
                                    extension = '';
                                } else {
                                    extension = extension.toLowerCase();
                                }
                                $.ajax({
                                    async: false,
                                    type: "POST",
                                    url: "checkImportFile.json",
                                    data: {'importType': $('input[name=radio]:checked')[0].id,
                                        'extension': extension,
    ${_csrf.parameterName}: "${_csrf.token}"},
                                    success: function (response) {
                                        result = response;
                                    }
                                });
                                if (result === false) {
                                    $('#radio-error').text('<spring:message code="importFromOutput.formatError"/>');
                                    $('#radio-error').css('display', 'block');
                                }
                                return result;
                            } else
                                $('#radio-error').text('<spring:message code="importAssetFromCsvFile.emptyFile"/>');
                            $('#radio-error').css('display', 'block');
                            return false;
                        }
                        if (index === 3) {
                            $('#sourceType').val($('input[name=radio]:checked')[0].id);
                            $('#submit_form').submit();
                        }
                        if (index === 1) {
                            $('#form_wizard_1').find('.button-next').show();
                        }
                        handleTitle(tab, navigation, index);
                    },
                    onPrevious: function (tab, navigation, index) {
                        success.hide();
                        error.hide();
                        handleTitle(tab, navigation, index);
                    },
                    onTabShow: function (tab, navigation, index) {
                        var total = navigation.find('li').length;
                        var current = index + 1;
                        var $percent = (current / total) * 100;
                        $('#form_wizard_1').find('.progress-bar').css({
                            width: $percent + '%'
                        });

                        if (current === 2) {
                            if (${fileAdded} === true) {
                                index = 4;
                                $('.step-title', $('#form_wizard_1')).text('Step ' + (index + 1) + ' of ' + total);
                                jQuery('li', $('#form_wizard_1')).removeClass("completed");
                                var li_list = navigation.find('li');
                                for (var i = 0; i < index; i++) {
                                    jQuery(li_list[i]).addClass("completed");
                                }
                                jQuery(li_list[1]).removeClass("active");
                                jQuery(li_list[4]).addClass("active");
                                jQuery('#tab2').removeClass("active");
                                jQuery('#tab5').addClass("active");
                                $('#form_wizard_1').find('.button-next').hide();
                                $('#form_wizard_1').find('.button-submit').show();
                            } else {
                                if ($('input[name=radio]:checked')[0].id === "PENTEST") {
                                    $('#pentestFilter').css('display', 'block');
                                } else if($('input[name=radio]:checked')[0].id === "QUALYS") {
                                    $('#qualysOptions').css('display', 'block');
                                } else if($('input[name=radio]:checked')[0].id === "EXCEL") {
                                    $('#excelOptions').css('display', 'block');
                                }
                                else { 
                                    $('#qualysOptions').css('display', 'none');
                                    $('#excelOptions').css('display', 'none');
                                    $('#pentestFilter').css('display', 'none');
                                }
                            }

                        }
                        if (current === 1) {
                            if ("${error}" !== "none") {
                                 if ("${error}" === "sizeError") {
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html("<spring:message code="importFromOutput.size.error"/>");
                                    $("#buttonback").text("<spring:message code="generic.ok"/>");
                                    $("#buttonback").click(function(){
                                        window.location.href='importFromOutput.htm';
                                    });
                                    $("#alertModal").modal("show");
                                } 
                                else if ("${error}" === "sameNameAlreadyExist") {
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html("<spring:message code="importFromOutput.sameName.error"/>");
                                    $("#buttonback").text("<spring:message code="generic.ok"/>");
                                    $("#buttonback").click(function(){
                                        window.location.href='importFromOutput.htm';
                                    });
                                    $("#alertModal").modal("show");
                                    
                                } 
                                else if ("${error}" === "sameNessusAlreadyExist") {
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html("<spring:message code="importFromNessusOutput.alreadyExists.error"/>");
                                    $("#buttonback").text("<spring:message code="generic.ok"/>");
                                    $("#buttonback").click(function(){
                                        window.location.href='importFromOutput.htm';
                                    });
                                    $("#alertModal").modal("show");
                                } 
                                else if ("${error}" === "parseError") {
                                    alert("parse ereor");
                                    $("#alertModalBody").empty();
                                    $("#alertModalBody").html("<spring:message code="importFromOutput.parse.error"/>");
                                    $("#buttonback").text("<spring:message code="generic.ok"/>");
                                    $("#buttonback").click(function(){
                                        window.location.href='importFromOutput.htm';
                                    });
                                    $("#alertModal").modal("show");
                                }
                                
                            } else {
                                if (${fileAdded} === true) {
                                    index = 3;
                                    $('.step-title', $('#form_wizard_1')).text('Step ' + (index + 1) + ' of ' + total);
                                    jQuery('li', $('#form_wizard_1')).removeClass("completed");
                                    var li_list = navigation.find('li');
                                    for (var i = 0; i < index; i++) {
                                        jQuery(li_list[i]).addClass("completed");
                                    }
                                    jQuery(li_list[0]).removeClass("active");
                                    jQuery(li_list[3]).addClass("active");
                                    jQuery('#tab1').removeClass("active");
                                    jQuery('#tab4').addClass("active");
                                }
                            }
                        }
                    }
                });

                $('#form_wizard_1').find('.button-previous').hide();
                $('#form_wizard_1 .button-submit').click(function () {
                    if (${fileAdded} === true) {
                        blackScreen();
                        $.post("importFromOutputFilterConfirm.json", {
                            'matches[][]': matches,
                            'newScanName': $('#scanName').val(),
    ${_csrf.parameterName}: "${_csrf.token}"
                        }).done(function () {
                            top.location.href = "../pentest/listScans.htm";
                        }).fail(function () {
                            blackScreenClose();
                            $("#alertModalBody").empty();
                            $("#alertModalBody").html("<spring:message code="import.error"/>");
                            $("#alertModal").modal("show");
                        });
                    } else {
                        $('#submit_form').submit();
                    }

                }).hide();
                $('#country_list', form).change(function () {
                    form.validate().element($(this));
                });
            }
        };
    }();

    function selectAll() {
        var checkboxes = document.getElementsByName('nessus');
        var visiblecheckboxes = [];
        for (var i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].offsetHeight !== 0) {
                visiblecheckboxes.push(checkboxes[i]);
            }
        }
        var list = getCheckedBoxes('nessus');
        if (list !== null) {
            if (list.length === visiblecheckboxes.length) {
                for (var i = 0; i < checkboxes.length; i++) {
                    visiblecheckboxes[i].checked = false;
                }
            } else {
                for (var i = 0; i < visiblecheckboxes.length; i++) {
                    visiblecheckboxes[i].checked = true;
                }
            }
        } else {
            for (var i = 0; i < visiblecheckboxes.length; i++) {
                visiblecheckboxes[i].checked = true;
            }
        }
    }
    $(document).ready(function () {
        FormWizard.init();


        $('input[type=file]').bootstrapFileInput();
        $('.file-inputs').bootstrapFileInput();
        $('input[type=checkbox][name=kb]').change(
                function () {
                    var checkBoxes = document.getElementsByName("kb");
                    var count = 0;
                    for (var x = 0; x < checkBoxes.length; x++) {
                        if (checkBoxes[x].checked === true) {
                            count += 1;
                        }
                    }
                    for (var x = 0; x < checkBoxes.length; x++) {
                        if (checkBoxes[x].checked === false) {
                            checkBoxes[x].disabled = true;
                        }
                        if (count === 0) {
                            checkBoxes[x].disabled = false;
                        }
                    }
                }
        );
        $('#excelKb').val("false");
        $('#excelKb').on('change', function(){
            if($('#excelKb').is(":checked")){
                $('#excelKb').val("true");
            } else {
                $('#excelKb').val("false");
            }
        });
    });
</script>
<jsp:include page="../tool/jsInformationOkCancelModal.jsp" />
<jsp:include page="../tool/alertModal.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/wizard.css">
    <script type="text/javascript" >
        var nessusIds;
        var kbIds;
        var match = [];
        var matches = [];
        var boxes;

        function searchScannerVuln() {
            var input, filter, ul, li, a, i;
            input = $('#search1').val();
            filter = input.toUpperCase();
            ul = document.getElementById("list");
            li = ul.getElementsByTagName("li");
            for (i = 0; i < li.length; i++) {
                a = li[i].textContent;
                if (a.toUpperCase().indexOf(filter) > -1) {
                    li[i].style.display = "";
                } else {
                    li[i].style.display = "none";

                }
            }
        }
        function searchKbVuln() {
            var input, filter, ul, li, a, i;
            input = $('#search2').val();
            filter = input.toUpperCase();
            ul = document.getElementById("categoryList");
            li = ul.getElementsByTagName("li");
            for (i = 0; i < li.length; i++) {
                a = li[i].textContent;
                if (a.toUpperCase().indexOf(filter) > -1) {
                    li[i].style.display = "";
                } else {
                    li[i].style.display = "none";

                }
            }
        }
        function getCheckedBoxes(chkboxName) {
            var checkboxes = document.getElementsByName(chkboxName);
            var checkboxesChecked = [];
            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    checkboxesChecked.push(checkboxes[i].id);
                }
            }
            return checkboxesChecked.length > 0 ? checkboxesChecked : null;
        }
        function getChecked() {
            nessusIds = getCheckedBoxes("nessus");
            kbIds = getCheckedBoxes("kb");
            var match = nessusIds.concat(kbIds);
            matches.push(match);

            for (var x = 0; x < nessusIds.length; x++) {
                var id = nessusIds[x];
                var kbId = kbIds[0];
                var nessusName = document.getElementById(id).textContent;
                var node = document.createElement("LI");
                var textnode = document.createTextNode(nessusName);
                node.appendChild(textnode);
                document.getElementsByClassName(kbId)[0].appendChild(node);
                var parent = document.getElementById("list");
                var item = document.getElementById(id);
                parent.removeChild(item);
            }
            $('input:checkbox').removeAttr('checked');
            $('input:checkbox').attr("disabled", false);
        }

        /*   $(document).on('hide.bs.modal', '#confirmation', function () {
     
         $.post("clearImportData.json", {
        ${_csrf.parameterName}: "${_csrf.token}"
         });
         }); */

        function blackScreen() {
            $('#darkModal').modal('show');
            $("#darkModal").block({message: null});
            App.startPageLoading({animate: true});
        }

        function blackScreenClose() {
            $('#darkModal').modal('hide');
            $("#darkModal").unblock();
            App.stopPageLoading();
        }


    </script>

    <div class="row">
        <div class="col-lg-12">
            <h3 class="page-title">
                <ul class="page-breadcrumb breadcrumb"> <li>
                        <a class="title" href="../dashboard/index.htm"><spring:message code="main.theme.dashboard"/></a>
                        <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                    </li><li>
                        <a class="title" href="../pentest/listScans.htm"><spring:message code="listScans.title"/></a>
                        <i  class="far fa-circle" style="font-size: 10px; font-weight: 900;"></i>
                    </li>
                    <li>
                        <span class="title2"><spring:message code="importFromNessusOutput.importFromNessusOutput"/></span>
                    </li>
                </ul>
            </h3>
        </div>
    </div>
    <div class="portlet">
        <div class="panel-body raise-effect-panel form">
            <div class="portlet light " id="form_wizard_1">
                <div class="portlet-body form">
                <form:form id="submit_form" method="POST" commandName="pentestScan" role="form" onsubmit="blackScreen()" enctype="multipart/form-data" action="importFromOutput.htm?${_csrf.parameterName}=${_csrf.token}">
                    <div class="form-wizard">
                        <div class="form-body">
                            <div class="mt-element-step">
                                <div class="row step-line">
                                    <ul class="nav nav-tabs wizard">
                                        <li class="active">
                                            <a href="#tab1" data-toggle="tab" style="padding: 2.7px" aria-expanded="true">                                                
                                                <div class="mt-step-col first">
                                                    <div class="mt-step-number bg-dark font-grey"><i class="fas fa-book"></i></div>
                                                    <div><spring:message code="startScan.scanType"/></div>
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#tab2" data-toggle="tab" style="padding: 2.7px" aria-expanded="true">
                                                <div class="mt-step-col">
                                                    <div class="mt-step-number bg-dark font-grey"><i class="fas fa-file"></i></div>
                                                    <div><spring:message code="generic.addFile"/></div>
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#tab3" data-toggle="tab" style="padding: 2.7px" aria-expanded="true">
                                                <div class="mt-step-col">
                                                    <div class="mt-step-number bg-dark font-grey"><i class="icon-info"></i></div>
                                                    <div><spring:message code="listScans.scanDetails"/></div>
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#tab4" data-toggle="tab" style="padding: 2.7px" aria-expanded="true">
                                                <div class="mt-step-col">
                                                    <div class="mt-step-number bg-dark font-grey"><i class="fas fa-arrows-alt-h"></i></div>
                                                    <div><spring:message code="main.theme.vulnerabilityKbMatch"/></div>
                                                </div>
                                            </a>
                                        </li>
                                        <li >
                                            <a href="#tab5" data-toggle="tab" style="padding: 2.7px">
                                                <div class="mt-step-col last">
                                                    <div class="mt-step-number bg-dark font-grey"><i class="fas fa-check"></i></div>
                                                    <div><spring:message code="startScan.confirm"/></div>
                                                </div>
                                            </a>
                                        </li>
                                    </ul>
                                </div> 
                                <div class="col-lg-6 col-center-block" style="text-align: center;">
                                    <span id="radio-error" class="alert-danger errorStyle" style="display: none"></span>
                                </div>           
                            </div>
                            <div class="tab-content">
                                <div class="tab-pane active" id="tab1">
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="col-lg-11 col-center-block" style="text-align: center;">
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="NESSUS" class="radio" style="visibility:hidden;"/>
                                                    <label for="NESSUS" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/nessusText.png" alt="nessusLogo" />
                                                        <text style="font-size:15px">NESSUS</text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left" >
                                                    <input type="radio" name="radio" id="QUALYS" class="radio" style="visibility:hidden;"/>
                                                    <label for="QUALYS" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/qualys.png" alt="nessusLogo" />
                                                        <text style="font-size:15px">QUALYS</text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="ACUNETIX" class="radio" style="visibility:hidden;"/>
                                                    <label for="ACUNETIX" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/acunetix-logo.png" alt="acunetix logo" />
                                                        <text style="font-size:15px"></text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="BURP" class="radio" style="visibility:hidden;"/>
                                                    <label for="BURP" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/burpicon.png" alt="nessusLogo" />
                                                        <text style="font-size:15px">BURP</text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="APPSCAN" class="radio" style="visibility:hidden;"/>
                                                    <label for="APPSCAN" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/appscanicon.png" alt="nessusLogo" />
                                                        <text style="font-size:15px;text-align:right">APPSCAN</text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="FORTIFY" class="radio" style="visibility:hidden;"/>
                                                    <label for="FORTIFY" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/fortify.png" alt="nessusLogo" />
                                                        <text style="font-size:15px">FORTIFY</text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="CHECKMARX" class="radio" style="visibility:hidden;"/>
                                                    <label for="CHECKMARX" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/checkmarx-logo.png" alt="checkmarx Logo" />
                                                        <text style="font-size:10px;text-align:right">CHECKMARX</text></label>
                                                </div>        
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="WEBINSPECT" class="radio" style="visibility:hidden;"/>
                                                    <label for="WEBINSPECT" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/webinspect.png" alt="nessusLogo" /></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="ARACHNI" class="radio" style="visibility:hidden;"/>
                                                    <label for="ARACHNI" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/arachni-logo.png" alt="nessusLogo" />
                                                        <text style="font-size:15px"></text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="NETSPARKER" class="radio" style="visibility:hidden;"/>
                                                    <label for="NETSPARKER" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/netsparker-logo.png" alt="nessusLogo" />
                                                        <text style="font-size:10px">NETSPARKER</text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="NETSPARKERENT" class="radio" style="visibility:hidden;"/>
                                                    <label for="NETSPARKERENT" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/netsparker-cloud.png" alt="Netsparker Enterprise Logo" />
                                                        <text style="font-size:15px;text-align:right"></text></label>
                                                </div>        
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="WAPITI" class="radio" style="visibility:hidden;"/>
                                                    <label for="WAPITI" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/wapiti-logo.png" alt="nessusLogo" />
                                                        <text style="font-size:15px"></text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="PENTEST" class="radio" style="visibility:hidden;"/>
                                                    <label for="PENTEST" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/pentest.png" alt="nessusLogo" />
                                                        <text style="font-size:15px"></text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="EXCEL" class="radio" style="visibility:hidden;"/>
                                                    <label for="EXCEL" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/excel.png" alt="excelLogo" />
                                                        <text style="font-size:15px"></text></label>
                                                </div>
                                                <div class="col-lg-3 col-md-4 col-sm-6" style="text-align:left">
                                                    <input type="radio" name="radio" id="OWAPS" class="radio" style="visibility:hidden;"/>
                                                    <label for="OWAPS" style="width:100%">
                                                        <img height="85px" style="" src="${pageContext.request.contextPath}/resources/logo/owaps_logo.png" alt="owapsLogo" />
                                                        <text style="font-size:15px">Owaps Zap</text></label>
                                                </div>
                                            </div>
                                        </div>
                                        <input id="sourceType" name="sourceType" style="display: none"/>
                                    </div>
                                </div>
                                <div class="tab-pane" id="tab2">
                                    <div class="panel-body"> 
                                        <div class="row">
                                            <div class="col-lg-2 col-center-block">
                                                <label for="file" class="custom-file-upload" style="width:250px;font-size:20px">
                                                    <i class="fas fa-upload"></i> <spring:message code="importFromNessusOutput.selectFile"/>
                                                </label>
                                                <input id="file" name="file" type="file"/>
                                            </div>
                                        </div>
                                        <br>
                                        <div class="row" id="excelWarning" style="display: none">
                                            <div class="col-lg-2 col-center-block" style="font-size: 13px">
                                                <i class="fa fa-download"> </i><a href="../customer/getDataFile.htm?type=excel">&nbsp;<spring:message code="importFromOutput.excelSample"/></a>
                                            </div><br>
                                            <div class="col-lg-2 col-center-block" style="font-size: 13px">
                                                <i class="fa fa-info-circle"> </i>&nbsp;<spring:message code="importFromOutput.excelWarning"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="tab3">
                                    <div class="panel-body"> 
                                        <div class="row">
                                            <div class="col-lg-6 col-center-block">
                                                <div class="form-group">
                                                     <label data-toggle="tooltip" data-placement="right" title='<spring:message code="import.filterWarningName"/>'><spring:message code="listScans.name"/>&nbsp;<span><i class="fas fa-info-circle" style="color:black;font-size:13px;"></i></span></label>
                                                    <input class="form-control" path="scanName" id="scanName" name="scanName" placeholder=""/>
                                                </div>
                                                <div class="form-group">
                                                    <label data-toggle="tooltip" data-placement="right" title='<spring:message code="import.filterWarningLevel"/>'><spring:message code="import.minimum"/>&nbsp;<span><i class="fas fa-info-circle" style="color:black;font-size:13px;"></i></span></label>
                                                    <select id="riskLevels" name="level" class="js-example-basic-single js-states form-control" style="width: 100%;">
                                                        <option value="0">0</option>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                    </select>

                                                </div>
                                                <div class="form-group">
                                                    <label data-toggle="tooltip" data-placement="right" title='<spring:message code="import.filterWarningAssetGroup"/>'><spring:message code="addAssetGroup.group"/>&nbsp;<span><i class="fas fa-info-circle" style="color:black;font-size:13px;"></i></span></label>
                                                    <select id="groups" name="assetGroup[]" class="js-example-basic-multiple js-states form-control" multiple="multiple" style="width: 100%;">
                                                        <c:forEach items="${assetGroups}" var="group">
                                                            <option value="<c:out value="${group.groupId}"/>"><c:out value="${group.name}"/></option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="form-group" style="display: none" id="qualysOptions">
                                                    <label><spring:message code="importFromOutput.qualysType"/></label><br/>
                                                    <input style="margin-top: 0px;" type="checkbox" id="qualysPotential" name="qualysPotential" value="Potential" />  Potential
                                                    <input style="margin-top: 0px;" type="checkbox" id="qualysConfirmed" name="qualysConfirmed" value="Confirmed"/> Confirmed
                                                    <input style="margin-top: 0px;" type="checkbox" id="qualysInformational" name="qualysInformational" value="Informational"/> Informational
                                                    <div class="" style="color:#32c5d2">
                                                        <b><spring:message code="importFromOutput.qualysTypeWarning"/></b>
                                                    </div>
                                                </div> 
                                                <div class="form-group" id="excelOptions">
                                                    <label></label><br/>
                                                    <input style="margin-top: 0px;" type="checkbox" id="excelKb" name="excelKb" value="false" />  Zafiyetler Bilgi Bankası'nda var ise eşleştir.
                                                </div>
                                                <div class="form-group" style="display: none" id="pentestFilter">
                                                    <label><spring:message code="startScan.pentest"/></label>
                                                    <select id="pentestScans" name="pentestScans" class="js-example-basic-single js-states form-control" style="width: 100%;">
                                                        <option value="none"/></option>
                                                        <c:forEach items="${pentestScans}" var="pentestScan">
                                                            <option value="<c:out value="${pentestScan.scanId}"/>"><c:out value="${pentestScan.name}"/></option>
                                                        </c:forEach>
                                                    </select>
                                                    <div class="" style="color:#32c5d2">
                                                        <b><spring:message code="importFromOutput.addToPentest"/></b>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="tab4">
                                    <div class="panel-body"> 
                                        <div class="row">
                                            <div class="col-lg-12 col-center-block" style="" id="vulnerabilityMatch" >
                                                <c:choose>
                                                    <c:when test="${sessionScope.aggregationActive=='true'}">
                                                        <div class="col-lg-12">
                                                        <div class="row">
                                                            <br>
                                                            <br> 
                                                            <div class="col-lg-6" style="height: 500px;overflow-y:scroll">
                                                                <div class="portlet light dark-index bordered shadow-soft">
                                                                    <div class="portlet-title portlet-title-black">
                                                                        <div class="caption">
                                                                            <i class="icon-equalizer font-dark hide"></i>
                                                                            <span class="caption-subject font-dark bold uppercase longTextWrap"><i class="far fa-chart-bar"></i> <spring:message code="scanEngineVulnerabilities.title"/></span>
                                                                        </div>
                                                                    </div>
                                                                    <div style="padding-left:2%;" class="portlet-body">
                                                                        <div class="caption" style="float:right">
                                                                            <input class="form-control" id ="search1" onkeyup="searchScannerVuln()" placeholder="<spring:message code="generic.search"/>">      
                                                                        </div>
                                                                        <button id="selectAll1" onclick="selectAll();
                                                                                return false;" class="btn btn-default" ><spring:message code="generic.selectAll"/></button> 
                                                                        <br><br>
                                                                        <ul id="list" style="list-style-type: none">
                                                                            <c:forEach var="nessusCategory" items="${sessionScope.importObject.importCategories}">
                                                                                <li id="${nessusCategory.key}" style="font-size:13px;"> <input type="checkbox" name="nessus" id="${nessusCategory.key}" style="height: 15px;width: 15px;" > <c:out value="${nessusCategory.value}"/> </li>
                                                                                </c:forEach>
                                                                        </ul>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-6" style="height: 500px;overflow-y:scroll">
                                                                <div class="portlet light dark-index bordered shadow-soft">
                                                                    <div class="portlet-title portlet-title-black">
                                                                        <div class="caption">
                                                                            <i class="icon-equalizer font-dark hide"></i>
                                                                            <span class="caption-subject font-dark bold uppercase longTextWrap"><i class="far fa-chart-bar"></i> <spring:message code="knowledgeBaseVulnerabilities.title"/></span> 
                                                                        </div>
                                                                    </div>
                                                                    <div class="portlet-body">
                                                                        <div class="caption" style="float:right"><input class="form-control" id ="search2" onkeyup="searchKbVuln()" placeholder="<spring:message code="generic.search"/>"></div>
                                                                        <br><br>
                                                                        <ul id="categoryList" style="list-style-type: none">
                                                                            <c:forEach var="category" items="${sessionScope.importObject.kbCategories}">
                                                                                <li style="font-size:13px;"> <input type="checkbox" name="kb" id="${category.id}" style="height: 15px;width: 15px;" > <c:out value="${category.kbItemDescription.name}"/> </li>
                                                                                <ul class="${category.id}"></ul>
                                                                            </c:forEach>
                                                                        </ul>   
                                                                    </div>
                                                                </div>
                                                            </div><br><br>

                                                        </div>
                                                        <div class="row justify-content-md-center">
                                                            <div class="col-md-auto">
                                                            <a style="margin-left: 49%; margin-top: 3%; background-color: #FF8C00;border-color: #FF4500" id="match" onclick="getChecked()" class="btn btn-success"><spring:message code="match.title"/></a></div>
                                                        </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div style="text-align: center">
                                                            <b><spring:message code="importFromOutput.moduleNotActive"/></b>
                                                        </div> 
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>  
                                </div>
                                <div class="tab-pane" id="tab5">
                                    <div class="panel-body"> 
                                        <div class="row">
                                            <div class="col-lg-6 col-center-block" style="text-align: center">
                                                <b><c:out value="${assetCount}"/> <spring:message code="import.filterConfirmation1"/> <c:out value="${vulnerabilityCount}"/> <spring:message code="import.filterConfirmation2"/></b>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-actions">
                            <div class="row">
                                <div style="float:right;margin-right: 20px">
                                    <button type="reset" class="btn btn-success" style="margin-right: 5px" onclick="window.location = 'listScans.htm'"><spring:message code="generic.reset"/></button>
                                    <a href="javascript:;" class="btn btn-success button-previous">
                                        <i class="fas fa-angle-left"></i> <spring:message code="startScan.back"/> </a>
                                    <a href="javascript:;" class="btn btn-success button-next"> <spring:message code="startScan.next"/>
                                        <i class="fas fa-angle-right"></i>
                                    </a>
                                    <a href="javascript:;" class="btn btn-outline green button-submit"> <spring:message code="startScan.confirm"/>
                                        <i class="fas fa-check"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </form:form>
                </div>
            </div>
        </div>
        <div class="modal fade" id="darkModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">

        </div>
    </div>
</body>
</html>
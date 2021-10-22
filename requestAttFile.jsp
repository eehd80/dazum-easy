<%@ page contentType="text/html; charset=utf-8"%>
<%@include file="/WEB-INF/jsp/include/tagLibs.jsp"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<title>병원비, 약제비 서류 첨부 - DAZUM 다줌</title>

<%@include file="/WEB-INF/jsp/include/include.jsp"%>

<script type="text/javascript">

$(document).ready(function() { 
    $(".input-file2").change(function() {
        var pos = $(".input-file2").index(this);
        
        $(".input-file-name").eq(pos).text("");
        $(".input-file-name").eq(pos).show();
        
        /*
        var seqNo = $("input[name='seqNo']", document.easyCmpsForm).eq(pos).val();
        alert(seqNo);
        $("input[name='attDoc']", document.attDocForm).remove(); // 기존 첨부파일 복사된게 있으면 삭제
        $("#seqNo", document.attDocForm).val(seqNo); // seqNo가 없으면 추가, 있으면 수정
        $(this).clone().appendTo(document.attDocForm); // easyCmpsForm에서 선택한 File객체 Clone생성하여 복사
        
        return;
        
        $("#attDocForm").ajaxSubmit({
            url : "<c:url value='/cmps/req/saveRequestAttFile.do'/>",
            type: "POST",
            dataType: "json",    
            success : function(result) {
                // 정상 처리된 경우
                if (result.resultCode == "1") {
                    location.href = "<c:url value='/cmps/req/checkRequestInfo.do'/>";
                } else {
                    alert(result.resultMessage);
                }
            },
            error: function(e){
                alert(e.responseText);
            }
        });
        */
        
        /*
        // Html5로 Base64로 인코딩하는 경우 파일 사이즈가 좀만 크면 너무 오래걸림!!
        // jquery 문법으로 하면 안먹힘!!
        var file = document.querySelector("#file" + (pos+1));
        alert(file.value);
        var fileReader = new FileReader();
        
        fileReader.readAsDataURL(file.files[0]);
        
        fileReader.onload = function(e) { 
            $("textarea[name='atdocBase64Str']").eq(pos).val(e.target.result);
            $("#img"+(pos+1)).attr("src", e.target.result);
        };

        fileReader.onerror = function(event) {
            alert("Failed to read file!\n\n" + fileReader.error);
        };
        */
    });
});

function goNextStep() {
    var saveYn = true;
    var allowedFileExts = "gif,jpg,png,bmp";
    
    $("input[name='attDoc']").each(function(index) {
        var attDocNm = $("input[name='attDoc']").eq(index).val();
        var fileExt = attDocNm.substring(attDocNm.lastIndexOf(".")+1);
        
        if (attDocNm != "") {
            if (allowedFileExts.indexOf(fileExt) < 0) {
                alert(fileExt + "은[는] 허용되지 않는 확장자입니다.");
                saveYn = false;
                return;
            }
        } 
    });
    
    if (!saveYn) {
        return;    
    }
    
    $("#easyCmpsForm").ajaxSubmit({
        url : "<c:url value='/cmps/req/saveRequestAttFile.do'/>",
        type: "POST",
        dataType: "json",    
        success : function(result) {
            // 정상 처리된 경우
            if (result.resultCode == "1") {
                location.href = "<c:url value='/cmps/req/checkRequestInfo.do'/>";
            } else {
                alert(result.resultMessage);
            }
        },
        error: function(e){
            alert(e.responseText);
        }
    });
}

function addAttDocRow() {
    // 마지막 TR 복제해서 추가
    var lastRowClone = $("#attDocBoxClone").clone(true)
    lastRowClone.find("input").val("");
    $("#attDocContainer").append(lastRowClone);
    
    // 복제한 Div 이름 변경
    $(lastRowClone).attr("name", "attDocBox");
    $(lastRowClone).show();

    // 서류첨부 타이틀 인덱스 재설정
    $("div[name='attDocBox'] p").each(function(index){
        $(this).text("서류첨부 " + (index+1));
    });
    
}

function deleteAttDocInfo(element, seqNo) {
    if (!confirm("삭제하시겠습니까?")) {
        return;
    }
    
    $.ajax({
        url : "<c:url value='/cmps/req/deleteRequestAttFile.do'/>",
        type: "POST",
        data : {"rquNo":$("#rquNo").val(), "seqNo":seqNo},
        dataType: "json",    
        success : function(result) {
            // 정상 처리된 경우
            if (result.resultCode == "1") {
                alert("삭제 되었습니다.");
                deleteAttDocRow(element);
            }
        },
        error: function(){
            alert("오류가 발생했습니다.");
        }
    });

}

function deleteAttDocRow(element) {
    $(element).closest("div").remove();
    
    // 서류첨부 타이틀 인덱스 재설정
    $("div[name='attDocBox'] p").each(function(index){
        $(this).text("서류첨부 " + (index+1));
    });
}

function viewAttDoc(element) {
    var atdocBase64Str = $(element).closest("div").children("input[name='atdocBase64Str']").val();
    //var atdocBase64Str = $("input[name='atdocBase64Str']").eq(index).val();
    
    $("#attDocImg").attr("src", "data:image/png;base64," + atdocBase64Str);
    
    openPopup('#attDocViewer');
}
</script>

</head>

<body>
    <c:import url="/WEB-INF/jsp/include/header.jsp" >
        <c:param name="title" value="간편청구" />
    </c:import>
    
    <!-- Content -->
    <div id="content">
        <div class="sub-header sub-01">
            <div class="container">
                <h2 class="title">간편청구</h2>
            </div>
        </div>

        <div class="sub-body">
            <div class="sub-content billing-content">
                <div class="find-billing-wrap">
                    <!-- 간편청구 -->
                    <section class="section">
                        <div class="container">
                            <!-- 
                            <form id="attDocForm" name="attDocForm" method="post" enctype="multipart/form-data">
                                <input type="hidden" id="slfChdRquDscd" name="slfChdRquDscd" value="${param.slfChdRquDscd}">
                                <input type="hidden" id="rquNo" name="rquNo" value="${param.rquNo}">
                                <input type="text" id="seqNo" name="seqNo"/>
                                
                            </form>
                            -->
                            
                            <form id="easyCmpsForm" name="easyCmpsForm" method="post" enctype="multipart/form-data">
                                <input type="hidden" id="slfChdRquDscd" name="slfChdRquDscd" value="${param.slfChdRquDscd}">
                                <input type="hidden" id="rquNo" name="rquNo" value="${param.rquNo}">

                                <div class="tit-wrap">
                                    <h3 class="primary-title-t2">병원비, 약제비 서류를 첨부해주세요.</h3>
                                    <a href="javascript:openPopup('#billingDocument');" class="btn-primary">청구서류 예시</a>
                                    <!-- <h3 class="primary-title-t2">피보험자 서명을 해주세요.</h3> -->
                                    <div class="step-t2">
                                        <a href="#" class="btn-arrow btn-prev">이전페이지로 이동</a>
                                        <em class="custom_paging"><strong>7</strong> / 7</em>
                                        <a href="#" class="btn-arrow btn-next">다음페이지로 이동</a>
                                    </div>
                                </div>

                                <div class="result-wrap billing-step">
                                    <c:forEach items="${attDocList}" var="attDoc" varStatus="status">
                                        <div name="attDocBox" class="form-row">
                                            <p class="form-label">서류첨부 ${status.index+1}</p>
                                            <div class="input-file-wrap input-file-disabled">
                                                <label for="file${status.index+1}" class="label-file">
                                                    <input type="text" id="file${status.index+1}" name="attDoc" class="input-file2" onclick="viewAttDoc(this)"/>
                                                    <!-- <input type="file" id="file${status.index+1}" name="attDoc" class="input-file2" accept=".gif, .jpg, .png, .bmp"/> -->
                                                </label>
                                                <span class="input-file-name">${attDoc.atdocNm}</span>
                                                <input type="hidden" name="atdocBase64Str" value="${attDoc.atdocBase64Str}">
                                            </div>
                                            <button class="btn- btn-delete" onclick="deleteAttDocInfo(this, '${attDoc.seqNo}'); return false;">- 파일삭제</button>
                                        </div>
                                    </c:forEach>
                                    
                                    <c:if test="${fn:length(attDocList) < 5}">
                                        <div id="attDocContainer" name="attDocBox" class="form-row">
                                            <c:forEach var="i" begin="${fn:length(attDocList)+1}" end="5">
                                                <div class="input-file-wrap">
                                                    <p class="form-label">서류첨부 ${i}</p>
                                                    <div class="filebox">
                                                        <input class="inp-upload" value="첨부파일" placeholder="첨부파일" />
                                                        <label for="file${i}" class="btn-sm">파일추가</label>
                                                    </div>
                                                    <input type="file" id="file${i}" name="attDoc" class="inp-file" accept=".gif, .jpg, .png, .bmp" />
                                                    <button class="btn- btn-delete" onclick="deleteAttDocRow(this); return false;">- 파일삭제</button>
                                                </div>                                            
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                    
                                    <div id="addBtnBox" class="form-row">
                                        <button class="btn-blue" onclick="addAttDocRow(); return false;">+ 서류첨부 추가</button>
                                    </div>
                                </div>

                                <!-- 서류첨부 추가용 Hidden Div ( 버튼 클릭시 이 Div를 복제해서 추가함 )-->
                                <div id="attDocBoxClone" class="input-file-wrap" style="display:none">
                                    <p class="form-label">서류첨부</p>
                                    <div class="filebox">
                                        <input class="inp-upload" value="첨부파일" placeholder="첨부파일" />
                                        <label for="file" class="btn-sm">파일추가</label>
                                    </div>
                                    <input type="file" id="file" name="attDoc" class="inp-file" accept=".gif, .jpg, .png, .bmp" />
                                    <button class="btn- btn-delete" onclick="deleteAttDocRow(this); return false;">- 파일삭제</button>
                                </div>                                            
                                <!-- ################################################################################# -->
                                
                                <div class="btn-wrap-easy">
                                    <button class="btn- btn-white" onclick="goPrevStep()">이전</button>
                                    <button class="btn- btn-submit" onclick="goNextStep();return false;">다음</button>
                                </div>
                            </form>
                        </div>
                    </section>
                    <!-- 간편청구 -->
                </div>
            </div>
        </div>
    </div>

    <!-- 청구서류 예시 팝업 -->
    <div id="billingDocument" class="modal-popup">
        <!-- 간편청구 로그인 -->
        <div role="dialog" class="modal-container">
            <div class="modal-header">
                <h3 class="tit-">청구서류 예시</h3>
                <p class="txt-">청구 시 아래와 같은 서류가 필요합니다.</p>
                <button type="button" class="btn-close-popup js-close-popup"><span class="sr-text">창닫기</span></button>
            </div>
            <div class="modal-content">
                <div class="popup-view">
                    <div class="view-body">
                        <ul role="tablist" class="tabs liner-tabs">
                            <li class="on" aria-selected="true">
                                <a href="#mainCategory1" role="tab" aria-selected="true">진료비 영수증</a>
                            </li>
                            <li class="" aria-selected="false">
                                <a href="#mainCategory2" role="tab" aria-selected="false">약제비 영수증</a>
                            </li>
                        </ul>
                        <div role="tabpanel" id="mainCategory1" class="tab-panel on">
                            <p class="txt-desc">일반 통원 치료 [병원에서 발급]</p>
                            <img src="${pageContext.request.contextPath}/static/img/easy/img-receipt-clinic.png" alt="진료비 영수증" class="img-receipt" />
                            <p class="txt-desc-s txt-center">위 사진은 청구를 돕기 위한 예시입니다.</p>
                        </div>
                        <div role="tabpanel" id="mainCategory2" class="tab-panel">
                            <p class="txt-desc">처방전 약 복용 [약국 봉투]</p>
                            <img src="${pageContext.request.contextPath}/static/img/easy/img-receipt-medicine.png" alt="약제비 영수증" class="img-receipt" />
                            <p class="txt-desc-s txt-center">위 사진은 청구를 돕기 위한 예시입니다.</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="popup-action">
                <a href="#mdReviewWrite" aria-haspopup="dialog" class="btn-cancel js-close-popup js-open-popup">닫기</a>
            </div>
        </div>
    </div>
    <!-- //청구서류 예시 팝업 -->

    <!-- 첨부파일(이미지) 보기 팝업 -->
    <div id="attDocViewer" class="modal-popup">
        <div role="dialog" class="modal-container">
            <div class="modal-content">
                <div class="popup-view">
                    <div class="view-body">
                        <img id="attDocImg" src="" class="img-receipt" style="width:100%; height:100%">
                    </div>
                </div>
            </div>
            <div class="popup-action">
                <a href="#mdReviewWrite" aria-haspopup="dialog" class="btn-cancel js-close-popup js-open-popup">닫기</a>
            </div>
        </div>
    </div>
    <!-- //첨부파일(이미지) 보기 팝업 -->

    <c:import url="/WEB-INF/jsp/include/smallFooter.jsp" />
    
</body>
</html>

<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>

<html><head>
    <%@ include file="head.jsp" %>
    <script type="text/javascript">
        if (window != window.top) {
            top.location.href = location.href;
        }
    </script>
	<link href="../style/fontawsome/css/fontawesome-all.min.css" rel="stylesheet">
	<link href="//fonts.googleapis.com/css?family=Lato" rel="stylesheet">

</head>
<body>
    
    <header>
		<div class="container">
			<h1>Booksonic</h1>
		</div>
	</header>
		
	<section id="water">
		<div class="container overlay">
			<div id="loginBox">
				<h1>Sign in to start your session</h1>
                <c:if test="${model.insecure}">
                    <div class="loginmessagebottom">
                        <p class="warning"><fmt:message key="login.insecure"><fmt:param value="${model.brand}"/></fmt:message></p>
                    </div>
                </c:if>
                <form action="<c:url value='/login'/>" method="POST">
                    <sec:csrfInput />
                    <input required type="text" autofocus id="j_username" name="j_username" tabindex="1" placeholder="<fmt:message key='login.username'/>">
                    <input required type="password" autocomplete="off"  name="j_password" tabindex="2" placeholder="<fmt:message key='login.password'/>">                    
                    <label for="remember"><fmt:message key="login.remember"/></label>
                    <input type="checkbox" name="remember-me" id="remember" tabindex="3">                    
                     |
                     <a href="recover.view"><fmt:message key="login.recover"/></a>
                    
                    <button type="submit">Sign In</button>
                </form>
                <div>
                    ${model.loginMessage}
                    
                    <c:if test="${model.error}">
                        <div class="loginmessagebottom">
                            <span class="warning"><fmt:message key="login.error"/></span>
                        </div>
                    </c:if>
                </div>
                
			</div>
		</div>
	</section>
		
	<section id="boxes">
		<div class="container">
			<div class="box">
				<i class="fab fa-github"></i>
				<p>Fully Open-Source.<br/>You can find the code on <a href="https://github.com/popeen?tab=repositories&q=booksonic" target="_blank">GitHub</a>
			</div>
			<div class="box">
				<i class="fas fa-cloud"></i>
				<p>Stream your audiobooks to any pc or android phone. Most of the functionality is also available on other platforms that have apps for subsonic.</p>
			</div>
			<div class="box">
				<a href="https://play.google.com/store/apps/details?id=github.popeen.dsub"><i class="fab fa-android"></i></a>
				<p>Get the Android app on <a href="https://play.google.com/store/apps/details?id=github.popeen.dsub">Google Play</a><br/>or build it from <a href="https://github.com/popeen/Popeens-DSub">source</a></p>
			</div>
		</div>
	</section>

</body>
</html>

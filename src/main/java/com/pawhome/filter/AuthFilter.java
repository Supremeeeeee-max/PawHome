package com.pawhome.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication and Authorization filter.
 * FIXED: dispatcherTypes = REQUEST only, so this filter does NOT run on
 * internal forwards (servlet forwarding to JSP). This prevents the infinite
 * loop where: servlet -> forward to JSP -> filter catches JSP -> calls servlet again.
 */
@WebFilter(
        filterName = "AuthFilter",
        urlPatterns = {"/admin/*", "/user/*"},
        dispatcherTypes = {DispatcherType.REQUEST}
)
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[AuthFilter] Initialized with dispatcherTypes = REQUEST only.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);

        if (!isLoggedIn) {
            httpResponse.sendRedirect(contextPath + "/login?error=Please+login+to+continue");
            return;
        }

        // Check role-based access for admin pages
        if (uri.startsWith(contextPath + "/admin/")) {
            String userRole = (String) session.getAttribute("userRole");
            if (!"admin".equals(userRole)) {
                httpResponse.sendRedirect(contextPath + "/error.jsp?code=403");
                return;
            }
        }

        // Check role-based access for user pages
        if (uri.startsWith(contextPath + "/user/")) {
            String userStatus = (String) session.getAttribute("userStatus");
            if (!"approved".equals(userStatus)) {
                httpResponse.sendRedirect(contextPath + "/login?error=Your+account+is+not+yet+approved");
                return;
            }
        }

        // User is authenticated and authorized, continue
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
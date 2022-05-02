package com.ring.fileUploadManagementModel;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Files;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * The Image servlet for serving from absolute path.
 *
 * @author BalusC
 * @link http://balusc.blogspot.com/2007/04/imageservlet.html
 */
@WebServlet(name = "ImageServlet", urlPatterns = {"/ImageServlet/*"})
public class ImageServlet extends HttpServlet {

    // Properties ---------------------------------------------------------------------------------
    private String imagePath;

    // Init ---------------------------------------------------------------------------------------
    public void init() throws ServletException {
//        //////////////System.out.println("1");
        // Define base path somehow. You can define it as init-param of the servlet.
        //  this.imagePath = "D:/";
//        String path = "/opt/";//"/opt/nps/images";//"D:/nanobtz";//
        String path = "";//"/opt/nps/images";//"D:/nanobtz";//
        this.imagePath = path;
        // In a Windows environment with the Applicationserver running on the
        // c: volume, the above path is exactly the same as "c:\var\webapp\images".
        // In Linux/Mac/UNIX, it is just straightforward "/var/webapp/images".
    }

    // Actions ------------------------------------------------------------------------------------
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

//        //////////////System.out.println("2");
        // Get requested image by path info.
        String requestedImage = request.getPathInfo();

        if (request.getSession().getAttribute("nowLoginUser") == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404.
            return;

        }

        // Check if file name is actually supplied to the request URI.
        if (requestedImage == null) {
            // Do your thing if the image is not supplied to the request URI.
            // Throw an exception, or send 404, or show default/warning image, or just ignore it.
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404.
            return;
        }

        // Decode the file name (might contain spaces and on) and prepare file object.
        File image = new File(imagePath, URLDecoder.decode(requestedImage, "UTF-8"));

        // Check if file actually exists in filesystem.
        if (!image.exists()) {
            // Do your thing if the file appears to be non-existing.
            // Throw an exception, or send 404, or show default/warning image, or just ignore it.
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404.
            return;
        }

        // Get content type by filename.
        String contentType = getServletContext().getMimeType(image.getName());

        // Check if file is actually an image (avoid download of other files by hackers!).
        // For all content types, see: http://www.w3schools.com/media/media_mimeref.asp
//        if (contentType == null || !contentType.startsWith("image")) {
//            // Do your thing if the file appears not being a real image.
//            // Throw an exception, or send 404, or show default/warning image, or just ignore it.
//            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404.
//            return;
//        }else  if (contentType == null || !contentType.startsWith("image")) {
//            // Do your thing if the file appears not being a real image.
//            // Throw an exception, or send 404, or show default/warning image, or just ignore it.
//            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404.
//            return;
//        }
        // Init servlet response.
        response.reset();
        response.setContentType(contentType);
        response.setHeader("Content-Length", String.valueOf(image.length()));

        // Write image content to response.
        Files.copy(image.toPath(), response.getOutputStream());
    }

}

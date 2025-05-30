package com.example.CandleShop.controller.user;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ContactController {

    @GetMapping("/contact")
    public String showContactPage() {
        return "user/contact";
    }

    @PostMapping("/contact/submit")
    public String submitContact(@RequestParam String fullname,
                                @RequestParam String email,
                                @RequestParam String phone,
                                @RequestParam String message,
                                RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("message", "Thank you for your message. We will contact you soon!");
        return "redirect:/contact";
    }
}


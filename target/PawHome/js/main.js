// PawHome - Main JavaScript

// Mobile navigation toggle
function toggleNav() {
    var navLinks = document.getElementById('navLinks');
    if (navLinks) {
        navLinks.classList.toggle('show');
    }
}

// Confirm delete actions
function confirmDelete(message) {
    return confirm(message || 'Are you sure you want to delete this item?');
}

// Form validation helper - highlight invalid fields
function validateRequired(formId) {
    var form = document.getElementById(formId);
    if (!form) return true;

    var inputs = form.querySelectorAll('[required]');
    var isValid = true;

    inputs.forEach(function(input) {
        if (!input.value.trim()) {
            input.style.borderColor = '#dc2626';
            isValid = false;
        } else {
            input.style.borderColor = '#e5e7eb';
        }
    });

    return isValid;
}

// Auto-hide alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function() {
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(function() {
                alert.style.display = 'none';
            }, 500);
        }, 5000);
    });
});

// Image preview on file input
function previewImage(input, previewId) {
    var preview = document.getElementById(previewId);
    if (input.files && input.files[0] && preview) {
        var reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// Name validation - no numbers allowed
function validateName(input) {
    var value = input.value;
    var pattern = /^[A-Za-z\s]*$/;
    if (!pattern.test(value)) {
        input.value = value.replace(/[^A-Za-z\s]/g, '');
        showFieldError(input, 'Name must contain only letters and spaces.');
    } else {
        clearFieldError(input);
    }
}

// Phone validation - only digits
function validatePhone(input) {
    var value = input.value;
    input.value = value.replace(/[^0-9]/g, '');
}

function showFieldError(input, message) {
    var existing = input.parentElement.querySelector('.field-error');
    if (!existing) {
        var errorSpan = document.createElement('span');
        errorSpan.className = 'field-error';
        errorSpan.style.cssText = 'color:#dc2626;font-size:0.8125rem;display:block;margin-top:2px;';
        errorSpan.textContent = message;
        input.parentElement.appendChild(errorSpan);
    }
    input.style.borderColor = '#dc2626';
}

function clearFieldError(input) {
    var existing = input.parentElement.querySelector('.field-error');
    if (existing) existing.remove();
    input.style.borderColor = '#e5e7eb';
}

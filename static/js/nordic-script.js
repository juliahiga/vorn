// VORN - Nordic Script
document.addEventListener('DOMContentLoaded', function() {
    
    // Mobile Navigation Toggle
    const navToggle = document.querySelector('.nav-toggle');
    const navLinks = document.querySelector('.nav-links');
    
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', function() {
            navLinks.classList.toggle('active');
            navToggle.classList.toggle('active');
        });
    }
    
    // Smooth Scrolling for Navigation Links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            
            if (target) {
                const headerHeight = document.querySelector('.nordic-nav').offsetHeight;
                const targetPosition = target.offsetTop - headerHeight;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
                
                // Close mobile menu if open
                if (navLinks.classList.contains('active')) {
                    navLinks.classList.remove('active');
                    navToggle.classList.remove('active');
                }
            }
        });
    });
    
    // Navbar Scroll Effect
    const navbar = document.querySelector('.nordic-nav');
    let lastScrollTop = 0;
    
    window.addEventListener('scroll', function() {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        if (scrollTop > lastScrollTop && scrollTop > 100) {
            // Scrolling down
            navbar.style.transform = 'translateY(-100%)';
        } else {
            // Scrolling up
            navbar.style.transform = 'translateY(0)';
        }
        
        // Add/remove background based on scroll
        if (scrollTop > 50) {
            navbar.style.background = 'rgba(248, 250, 252, 0.98)';
            navbar.style.boxShadow = '0 2px 20px rgba(15, 23, 42, 0.1)';
        } else {
            navbar.style.background = 'rgba(248, 250, 252, 0.95)';
            navbar.style.boxShadow = 'none';
        }
        
        lastScrollTop = scrollTop;
    });
    
    // Intersection Observer for Animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    // Observe elements for animation
    document.querySelectorAll('.feature-card, .tool-item, .campaign-card-preview').forEach(el => {
        observer.observe(el);
    });
    
    // Rune Circle Animation Control
    const runeCircle = document.querySelector('.rune-circle');
    let isHovered = false;
    
    if (runeCircle) {
        runeCircle.addEventListener('mouseenter', function() {
            if (!isHovered) {
                isHovered = true;
                this.style.animationDuration = '2s';
                setTimeout(() => {
                    this.style.animationDuration = '30s';
                    isHovered = false;
                }, 2000);
            }
        });
    }
    
    // Parallax Effect for Hero Background
    const heroBackground = document.querySelector('.nordic-pattern');
    
    if (heroBackground) {
        window.addEventListener('scroll', function() {
            const scrolled = window.pageYOffset;
            const rate = scrolled * -0.5;
            heroBackground.style.transform = `translate3d(0, ${rate}px, 0)`;
        });
    }
    
    // Stats Counter Animation
    function animateCounters() {
        const counters = document.querySelectorAll('.stat-number');
        
        counters.forEach(counter => {
            const target = parseInt(counter.textContent.replace(/[^\d]/g, ''));
            const suffix = counter.textContent.replace(/[\d]/g, '');
            let current = 0;
            const increment = target / 100;
            const timer = setInterval(() => {
                current += increment;
                if (current >= target) {
                    counter.textContent = target + suffix;
                    clearInterval(timer);
                } else {
                    counter.textContent = Math.floor(current) + suffix;
                }
            }, 20);
        });
    }
    
    // Trigger counter animation when stats section is visible
    const statsSection = document.querySelector('.campaign-stats');
    if (statsSection) {
        const statsObserver = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateCounters();
                    statsObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.5 });
        
        statsObserver.observe(statsSection);
    }
    
    // Interactive Runes
    const runes = document.querySelectorAll('.rune');
    const runeMessages = [
        'Força', 'Coragem', 'Sabedoria', 'Honor',
        'Vitória', 'Proteção', 'Sorte', 'Poder'
    ];
    
    runes.forEach((rune, index) => {
        rune.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.3)';
            this.style.color = '#F59E0B';
            this.title = runeMessages[index];
        });
        
        rune.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
            this.style.color = '';
        });
    });
    
    // Feature Cards Hover Effect
    document.querySelectorAll('.feature-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.querySelector('.feature-icon').style.background = 'linear-gradient(135deg, #F59E0B 0%, #D97706 100%)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.querySelector('.feature-icon').style.background = '';
        });
    });
    
    // Button Ripple Effect
    function createRipple(event) {
        const button = event.currentTarget;
        const circle = document.createElement('span');
        const diameter = Math.max(button.clientWidth, button.clientHeight);
        const radius = diameter / 2;
        
        circle.style.width = circle.style.height = `${diameter}px`;
        circle.style.left = `${event.clientX - button.offsetLeft - radius}px`;
        circle.style.top = `${event.clientY - button.offsetTop - radius}px`;
        circle.classList.add('ripple');
        
        const ripple = button.getElementsByClassName('ripple')[0];
        
        if (ripple) {
            ripple.remove();
        }
        
        button.appendChild(circle);
        
        setTimeout(() => {
            circle.remove();
        }, 600);
    }
    
    // Add ripple effect to buttons
    document.querySelectorAll('.btn-primary, .btn-secondary, .btn-cta').forEach(button => {
        button.addEventListener('click', createRipple);
    });
    
    // Keyboard Navigation
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && navLinks.classList.contains('active')) {
            navLinks.classList.remove('active');
            navToggle.classList.remove('active');
        }
    });
    
    // Performance Optimization: Throttle scroll events
    function throttle(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
    
    // Apply throttling to scroll events
    const throttledScroll = throttle(function() {
        // Custom scroll logic here if needed
    }, 100);
    
    window.addEventListener('scroll', throttledScroll);
    
    // Preload critical images
    function preloadImages() {
        const imageUrls = [
            // Add any critical image URLs here
        ];
        
        imageUrls.forEach(url => {
            const img = new Image();
            img.src = url;
        });
    }
    
    preloadImages();
    
    // Add loading states for interactive elements
    document.querySelectorAll('.btn-primary, .btn-secondary, .btn-cta').forEach(button => {
        button.addEventListener('click', function() {
            if (!this.classList.contains('loading')) {
                this.classList.add('loading');
                setTimeout(() => {
                    this.classList.remove('loading');
                }, 2000);
            }
        });
    });
    
    // Accessibility improvements
    function enhanceAccessibility() {
        // Add ARIA labels to interactive elements
        document.querySelectorAll('.feature-card').forEach((card, index) => {
            card.setAttribute('tabindex', '0');
            card.setAttribute('aria-label', `Recurso ${index + 1}`);
        });
        
        // Add keyboard support for feature cards
        document.querySelectorAll('.feature-card').forEach(card => {
            card.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    this.click();
                }
            });
        });
    }
    
    enhanceAccessibility();
    
    // Dark mode toggle (optional feature)
    function initDarkMode() {
        const darkModeToggle = document.querySelector('.dark-mode-toggle');
        
        if (darkModeToggle) {
            darkModeToggle.addEventListener('click', function() {
                document.body.classList.toggle('dark-mode');
                const isDarkMode = document.body.classList.contains('dark-mode');
                localStorage.setItem('darkMode', isDarkMode);
            });
            
            // Check for saved dark mode preference
            const savedDarkMode = localStorage.getItem('darkMode');
            if (savedDarkMode === 'true') {
                document.body.classList.add('dark-mode');
            }
        }
    }
    
    initDarkMode();
    
    console.log('🔨 VORN Nordic System initialized successfully!');
});

// CSS for ripple effect
const rippleStyle = document.createElement('style');
rippleStyle.textContent = `
    .ripple {
        position: absolute;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.6);
        transform: scale(0);
        animation: ripple-animation 0.6s linear;
        pointer-events: none;
    }
    
    @keyframes ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
    
    .btn-primary, .btn-secondary, .btn-cta {
        position: relative;
        overflow: hidden;
    }
    
    .loading {
        pointer-events: none;
        opacity: 0.7;
    }
    
    .loading::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 20px;
        height: 20px;
        margin: -10px 0 0 -10px;
        border: 2px solid transparent;
        border-top-color: currentColor;
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
        to {
            transform: rotate(360deg);
        }
    }
    
    .animate-in {
        animation: slideInUp 0.6s ease-out forwards;
    }
    
    @keyframes slideInUp {
        from {
            opacity: 0;
            transform: translateY(40px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
`;

document.head.appendChild(rippleStyle);
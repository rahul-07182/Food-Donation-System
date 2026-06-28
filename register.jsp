<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration - Food Donation System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 500px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #2c3e50;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .required {
            color: #e74c3c;
        }
        
        input[type="text"],
        input[type="password"],
        input[type="email"],
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ecf0f1;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        
        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="email"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #3498db;
        }
        
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .help-text {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            margin-top: 10px;
        }
        
        .btn-secondary:hover {
            box-shadow: 0 5px 15px rgba(149, 165, 166, 0.3);
        }
        
        .links {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #ecf0f1;
        }
        
        .links a {
            color: #3498db;
            text-decoration: none;
            font-size: 14px;
        }
        
        .links a:hover {
            text-decoration: underline;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
            display: none;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            display: none;
        }
        
        .validation-info {
            background-color: #e3f2fd;
            color: #1565c0;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #2196f3;
        }
        
        .validation-info h4 {
            margin-bottom: 10px;
            color: #0d47a1;
        }
        
        .validation-info ul {
            margin-left: 20px;
            font-size: 13px;
        }
        
        .validation-info li {
            margin-bottom: 5px;
        }
        
        @media (max-width: 600px) {
            .container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🍽️ User Registration</h1>
            <p>Join the Online Food Donation System</p>
        </div>
        
        <div class="validation-info">
            <h4>📋 Registration Requirements:</h4>
            <ul>
                <li><strong>Username:</strong> 3-20 characters, letters, numbers, underscores only</li>
                <li><strong>Password:</strong> Minimum 6 characters</li>
                <li><strong>Email:</strong> Valid email address required</li>
                <li><strong>Phone:</strong> Optional, 10-20 characters if provided</li>
                <li><strong>Address:</strong> Optional, 10-500 characters if provided</li>
            </ul>
        </div>
        
        <div id="errorMessage" class="error-message"></div>
        <div id="successMessage" class="success-message"></div>
        
        <form id="registrationForm" method="post" action="register" onsubmit="return validateForm()">
            
            <div class="form-group">
                <label for="username">Username: <span class="required">*</span></label>
                <input type="text" id="username" name="username" required 
                       placeholder="Choose a username" maxlength="20">
                <div class="help-text">This will be your login username</div>
            </div>
            
            <div class="form-group">
                <label for="password">Password: <span class="required">*</span></label>
                <input type="password" id="password" name="password" required 
                       placeholder="Enter your password" minlength="6">
                <div class="help-text">Minimum 6 characters</div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password: <span class="required">*</span></label>
                <input type="password" id="confirmPassword" name="confirmPassword" required 
                       placeholder="Confirm your password" minlength="6">
                <div class="help-text">Re-enter your password for confirmation</div>
            </div>
            
            <div class="form-group">
                <label for="fullName">Full Name: <span class="required">*</span></label>
                <input type="text" id="fullName" name="fullName" required 
                       placeholder="Enter your full name" maxlength="100">
                <div class="help-text">Your actual name as it appears on documents</div>
            </div>
            
            <div class="form-group">
                <label for="email">Email Address: <span class="required">*</span></label>
                <input type="email" id="email" name="email" required 
                       placeholder="your.email@example.com" maxlength="100">
                <div class="help-text">We'll use this for account verification</div>
            </div>
            
            <div class="form-group">
                <label for="phone">Phone Number:</label>
                <input type="text" id="phone" name="phone" 
                       placeholder="+1 (555) 123-4567" maxlength="20">
                <div class="help-text">Optional - include country code for international numbers</div>
            </div>
            
            <div class="form-group">
                <label for="address">Address:</label>
                <textarea id="address" name="address" placeholder="Enter your complete address" 
                          maxlength="500"></textarea>
                <div class="help-text">Optional - helps with food pickup/delivery coordination</div>
            </div>
            
            <div class="form-group">
                <label for="userType">User Type: <span class="required">*</span></label>
                <select id="userType" name="userType" required>
                    <option value="">Select your role</option>
                    <option value="donor">🎁 Food Donor</option>
                    <option value="ngo">🏢 NGO Representative</option>
                    <option value="admin">👨‍💼 System Administrator</option>
                </select>
                <div class="help-text">Choose the role that best describes you</div>
            </div>
            
            <button type="submit" class="btn">🚀 Register Account</button>
            <button type="button" class="btn btn-secondary" onclick="window.location.href='index.html'">
                🏠 Back to Home
            </button>
        </form>
        
        <div class="links">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
            <p><a href="index.html">← Back to Home</a></p>
        </div>
    </div>
    
    <script>
        // Client-side validation
        function validateForm() {
            const form = document.getElementById('registrationForm');
            const username = form.username.value.trim();
            const password = form.password.value;
            const confirmPassword = form.confirmPassword.value;
            const fullName = form.fullName.value.trim();
            const email = form.email.value.trim();
            const phone = form.phone.value.trim();
            const address = form.address.value.trim();
            const userType = form.userType.value;
            
            const errorDiv = document.getElementById('errorMessage');
            const successDiv = document.getElementById('successMessage');
            
            // Hide previous messages
            errorDiv.style.display = 'none';
            successDiv.style.display = 'none';
            
            // Validate required fields
            if (!username) {
                showError('Username is required.');
                return false;
            }
            
            if (username.length < 3 || username.length > 20) {
                showError('Username must be between 3 and 20 characters.');
                return false;
            }
            
            if (!/^[a-zA-Z0-9_]+$/.test(username)) {
                showError('Username can only contain letters, numbers, and underscores.');
                return false;
            }
            
            if (!password) {
                showError('Password is required.');
                return false;
            }
            
            if (password.length < 6) {
                showError('Password must be at least 6 characters long.');
                return false;
            }
            
            if (password !== confirmPassword) {
                showError('Passwords do not match.');
                return false;
            }
            
            if (!fullName) {
                showError('Full name is required.');
                return false;
            }
            
            if (fullName.length < 2 || fullName.length > 100) {
                showError('Full name must be between 2 and 100 characters.');
                return false;
            }
            
            if (!email) {
                showError('Email is required.');
                return false;
            }
            
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                showError('Please enter a valid email address.');
                return false;
            }
            
            if (!userType) {
                showError('Please select a user type.');
                return false;
            }
            
            // Optional field validations
            if (phone && (phone.length < 10 || phone.length > 20)) {
                showError('Phone number must be between 10 and 20 characters.');
                return false;
            }
            
            if (phone && !/^[\d\-\+\(\)\s]+$/.test(phone)) {
                showError('Please enter a valid phone number.');
                return false;
            }
            
            if (address && (address.length < 10 || address.length > 500)) {
                showError('Address must be between 10 and 500 characters.');
                return false;
            }
            
            // Show loading message
            showSuccess('Processing your registration... Please wait.');
            
            return true;
        }
        
        function showError(message) {
            const errorDiv = document.getElementById('errorMessage');
            const successDiv = document.getElementById('successMessage');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
            successDiv.style.display = 'none';
            
            // Scroll to top of form
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
        function showSuccess(message) {
            const errorDiv = document.getElementById('errorMessage');
            const successDiv = document.getElementById('successMessage');
            successDiv.textContent = message;
            successDiv.style.display = 'block';
            errorDiv.style.display = 'none';
            
            // Scroll to top of form
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
        // Real-time validation feedback
        document.getElementById('username').addEventListener('input', function() {
            const value = this.value;
            if (value.length > 0 && value.length < 3) {
                this.style.borderColor = '#e74c3c';
            } else if (/^[a-zA-Z0-9_]+$/.test(value) && value.length >= 3) {
                this.style.borderColor = '#27ae60';
            } else {
                this.style.borderColor = '#ecf0f1';
            }
        });
        
        document.getElementById('password').addEventListener('input', function() {
            const value = this.value;
            if (value.length > 0 && value.length < 6) {
                this.style.borderColor = '#e74c3c';
            } else if (value.length >= 6) {
                this.style.borderColor = '#27ae60';
            } else {
                this.style.borderColor = '#ecf0f1';
            }
        });
        
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const value = this.value;
            if (value.length > 0 && value !== password) {
                this.style.borderColor = '#e74c3c';
            } else if (value === password && value.length > 0) {
                this.style.borderColor = '#27ae60';
            } else {
                this.style.borderColor = '#ecf0f1';
            }
        });
        
        document.getElementById('email').addEventListener('input', function() {
            const value = this.value;
            if (value.length > 0 && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                this.style.borderColor = '#e74c3c';
            } else if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                this.style.borderColor = '#27ae60';
            } else {
                this.style.borderColor = '#ecf0f1';
            }
        });
    </script>
</body>
</html>

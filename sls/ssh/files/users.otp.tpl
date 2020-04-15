{% for user in users recursive %}
HOTP/T30/6	{{ user }}	-	{{ user.otp_key }}
{% endfor %}

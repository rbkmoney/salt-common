{% for user in users recursive %}
 {% if user.otp_key is defined %}
HOTP/T30/6	{{ user }}	-	{{ user.otp_key }}
 {% endif %}
{% endfor %}
{{ users }}
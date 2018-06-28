#/bin/bash
#Author: tritran
 
options=("Create User" "Delete User" "Quit")
 
# check file common client
IP=`hostname -I | awk '{print $1}'`
if [ ! -f /etc/openvpn/common-client.txt ]; then
    cat <<EOF >> /etc/openvpn/common-client.txt
client
dev tun
proto udp
sndbuf 0
rcvbuf 0
#remote 103.221.223.143 1194
remote $IP 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-128-CBC
comp-lzo
#setenv opt block-outside-dns
#remote-cert-tls server
pull-filter ignore "block-outside-dns"
key-direction 1
verb 3
EOF
fi
 
create_user(){
    read -p "input username here. Note the user does not include special characters and spaces: " user
    echo "$user"
    cd /etc/openvpn/easy-rsa/
    ./easyrsa gen-req $user nopass
    ./easyrsa sign-req client $user
    if [ ! -f ~/$user.ovpn ]; then
        cat /etc/openvpn/common-client.txt > ~/$user.ovpn
        echo "<ca>" >> ~/$user.ovpn
        cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$user.ovpn
        echo "</ca>" >> ~/$user.ovpn
        echo "<cert>" >> ~/$user.ovpn
        cat /etc/openvpn/easy-rsa/pki/issued/$user.crt >> ~/$user.ovpn
        echo "</cert>" >> ~/$user.ovpn
        echo "<key>" >> ~/$user.ovpn
        cat /etc/openvpn/easy-rsa/pki/private/$user.key >> ~/$user.ovpn
        echo "</key>" >> ~/$user.ovpn
        echo "<tls-auth>" >> ~/$user.ovpn
        cat /etc/openvpn/keys/ta.key >> ~/$user.ovpn
        echo "</tls-auth>" >> ~/$user.ovpn
        echo "Completed, please check ~/$user.ovpn"
    fi
}
 
delete_user(){
    read -p "input username You want delete here: " user
    cd /etc/openvpn/easy-rsa/
    ./easyrsa revoke $user
    ./easyrsa gen-crl
    rm -rf /etc/openvpn/easy-rsa/pki/reqs/$user.req
    rm -rf /etc/openvpn/easy-rsa/pki/issued/$user.crt
    rm -rf /etc/openvpn/easy-rsa/pki/private/$user.key
    echo "finished delete user"
}
 
PS3="========================Welcome to script confing openvpn========================"
PS3="Select options, Please: "
select opt in "${options[@]}"
do
    case $opt in
        "Create User")
        create_user
        break
        ;;
        "Delete User")
        delete_user
        break
        ;;
        "Quit")
        break
        ;;
        *) echo "invalid option"
    esac
done

package main

import (
	"context"
	"log"

	"fmt"

	db "github.com/ivanstepachev/vpn_cron/db"
)



func main() {
	log.Println("Starting Cron VPN")

	ctx := context.Background()

	DB, err := db.Init()
	if err != nil {
		log.Println(err.Error())
		return
	}
	q := db.New(DB)

	q.SendMessageAdmin(ctx, "Starting Cron VPN Daily")
	// Сохраним статистику
	
	tgUsersVPN, err := q.CountTgUsersDaily(ctx, "vpn")
	if err != nil {
		log.Println(err.Error())
		q.SendMessageAdmin(ctx, err.Error())
		return
	}
	tgUsersWalle, err := q.CountTgUsersDaily(ctx, "walle")
	if err != nil {
		log.Println(err.Error())
		q.SendMessageAdmin(ctx, err.Error())
		return
	}

	VPNUsersVPN, err := q.CountVPNUsersDaily(ctx, "vpn")
	if err != nil {
		log.Println(err.Error())
		q.SendMessageAdmin(ctx, err.Error())
		return
	}
	VPNUsersWalle, err := q.CountVPNUsersDaily(ctx, "walle")
	if err != nil {
		log.Println(err.Error())
		q.SendMessageAdmin(ctx, err.Error())
		return
	}

	usersChecking, err := q.AllUsers(ctx)
	if err != nil {
		log.Println(err.Error())
		q.SendMessageAdmin(ctx, err.Error())
		return
	}

	amountUsers := len(usersChecking)


	for i, user := range usersChecking {
		fmt.Println(i+1, "/", amountUsers, "   id: ", user.ID)
		q.SendPhoto(ctx, user, "https://ntens.ru/static/assets/wheel.jpg")
		message := "🔥Забери свой приз в нашем Колесе фортуны🎁\nВыиграй 30 000 руб или другой ценный приз за покупку подписки на VPN в течении 24 часов!😳\n\nПри покупке тарифа:\n\nНа 1 месяц - крути 1 раз\nНа 3 месяца - крути 2 раза\n\nАкция в честь нашей бесперебойной работы на протяжении 6 месяцев🔥"
		q.SendMessageToPay(ctx, user, message)
	}
	log.Println("Stop Cron VPN")
	q.SendMessageAdmin(ctx, "Stop Cron VPN Daily")
}
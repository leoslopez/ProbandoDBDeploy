/*Desactivar las relaciones en subscriberxlist de listas ya eliminadas (active == 0)*/
update subscriberxlist
set active = 0
where active = 1
	and idsubscribersList in (SELECT idsubscribersList
							FROM SubscribersList
							where active = 0)

/*Actualizar subscriptores que son ACTIVE (1) a INACTIVE (2) si no tienen ninguna relacion en subscriberXlist*/
update subscriber
set idsubscribersstatus = 2
where idsubscribersstatus = 1 and
	  idsubscriber not in (select idsubscriber from subscriberxlist)

/*Actualizar subscriptores que son ACTIVE (1) a INACTIVE (2) si todas las relaciones de subscriberXlist son active == 0*/
update subscriber
set idsubscribersstatus = 2
where idsubscribersstatus = 1
	and idsubscriber in (select idsubscriber from subscriberxlist where active = 0)
	and idsubscriber not in (select idsubscriber from subscriberxlist where active = 1)

/*Actualizar subscriptores que son ACTIVE (1) a INACTIVE (2) si las unicas relaciones en subscriberXlist son a listas visible == 0*/
update subscriber
set idsubscribersstatus = 2
where idsubscribersstatus = 1 and
	  idsubscriber in (select idsubscriber from subscriberxlist SXL join subscriberslist S on SXL.idsubscribersList = S.idsubscribersList and SXL.Active = 1 and S.visible = 0)
	  and idsubscriber not in (select idsubscriber from subscriberxlist SXL join subscriberslist S on SXL.idsubscribersList = S.idsubscribersList and SXL.Active = 1 and s.visible = 1)
     
    
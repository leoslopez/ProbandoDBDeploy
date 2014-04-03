  UPDATE dbo.UserTimeZone
  SET Name = '(GMT-06:00) Guadalajara, Mexico City, Monterrey',
      Offset = -360
  WHERE IdUserTimeZone = 11
  
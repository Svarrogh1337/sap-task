package routes

import (
	"app/models"
	"net/http"
	"github.com/gin-gonic/gin"
)

func getSysInfo(context *gin.Context) {
	events, err := models.SysInfo()
	if err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not parse request data. "})
		return
	}
	context.JSON(http.StatusOK, events)
}
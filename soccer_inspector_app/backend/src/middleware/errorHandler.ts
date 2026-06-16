<<<<<<< HEAD
// backend/src/middleware/errorHandler.ts
import { Request, Response, NextFunction } from 'express';
=======
import { Request, Response, NextFunction } from "express";
>>>>>>> backend_update

export const errorHandler = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
<<<<<<< HEAD
  console.error('Error:', error);
  
  res.status(500).json({
    error: 'Erro interno do servidor',
    message: process.env.NODE_ENV === 'development' ? error.message : undefined
=======
  console.error("❌ Error:", error);

  return res.status(500).json({
    success: false,
    error: "Erro interno do servidor",
    message:
      process.env.NODE_ENV === "development"
        ? error.message
        : undefined,
>>>>>>> backend_update
  });
};
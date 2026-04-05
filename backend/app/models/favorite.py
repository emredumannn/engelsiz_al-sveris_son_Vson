from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from app.db.base_class import Base

class Favorite(Base):
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    product_id = Column(Integer, ForeignKey("product.id"), nullable=False)

    user = relationship("User", back_populates="favorites")
    product = relationship("Product")

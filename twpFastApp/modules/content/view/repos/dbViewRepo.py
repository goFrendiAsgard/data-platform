from typing import List, Optional
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.engine import Engine
from sqlalchemy.orm import Session
from sqlalchemy import Boolean, Column, DateTime, ForeignKey, Integer, String
from schemas.view import View, ViewData
from modules.content.view.repos.viewRepo import ViewRepo
from repos import Base

import uuid
import datetime

class DBViewEntity(Base):
    __tablename__ = "views"
    id = Column(String(36), primary_key=True, index=True)
    content_id = Column(String(255), index=True)
    session_id = Column(String(255), index=True)
    user_id = Column(String(255), index=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    created_by = Column(String(36), nullable=True)
    updated_at = Column(DateTime, nullable=True)
    updated_by = Column(String(36), nullable=True)


class DBViewRepo(ViewRepo):

    def __init__(self, engine: Engine, create_all: bool):
        self.engine = engine
        if create_all:
            Base.metadata.create_all(bind=engine)


    def _get_keyword_filter(self, keyword: str) -> str:
        return '%{}%'.format(keyword) if keyword != '' else '%'


    def find_by_id(self, id: str) -> Optional[View]:
        db = Session(self.engine)
        view: View
        try:
            db_view = db.query(DBViewEntity).filter(DBViewEntity.id == id).first()
            if db_view is None:
                return None
            view = View.from_orm(db_view)
        finally:
            db.close()
        return view


    def find(self, keyword: str, limit: int, offset: int) -> List[View]:
        db = Session(self.engine)
        views: List[View] = []
        try:
            keyword_filter = self._get_keyword_filter(keyword)
            db_views = db.query(DBViewEntity).filter(DBViewEntity.content_id.like(keyword_filter)).offset(offset).limit(limit).all()
            views = [View.from_orm(db_result) for db_result in db_views]
        finally:
            db.close()
        return views


    def count(self, keyword: str) -> int:
        db = Session(self.engine)
        view_count = 0
        try:
            keyword_filter = self._get_keyword_filter(keyword)
            view_count = db.query(DBViewEntity).filter(DBViewEntity.content_id.like(keyword_filter)).count()
        finally:
            db.close()
        return view_count


    def insert(self, view_data: ViewData) -> Optional[View]:
        db = Session(self.engine)
        view: View
        try:
            new_view_id = str(uuid.uuid4())
            db_view = DBViewEntity(
                id=new_view_id,
                content_id=view_data.content_id,
                session_id=view_data.session_id,
                user_id=view_data.user_id,
                created_at=datetime.datetime.utcnow(),
                created_by=view_data.created_by,
                updated_at=datetime.datetime.utcnow(),
                updated_by=view_data.updated_by
            )
            db.add(db_view)
            db.commit()
            db.refresh(db_view) 
            view = View.from_orm(db_view)
        finally:
            db.close()
        return view


    def update(self, id: str, view_data: ViewData) -> Optional[View]:
        db = Session(self.engine)
        view: View
        try:
            db_view = db.query(DBViewEntity).filter(DBViewEntity.id == id).first()
            if db_view is None:
                return None
            db_view.content_id = view_data.content_id
            db_view.session_id = view_data.session_id
            db_view.user_id = view_data.user_id
            db_view.updated_at = datetime.datetime.utcnow()
            db_view.updated_by = view_data.updated_by
            db.add(db_view)
            db.commit()
            db.refresh(db_view) 
            view = View.from_orm(db_view)
        finally:
            db.close()
        return view


    def delete(self, id: str) -> Optional[View]:
        db = Session(self.engine)
        view: View
        try:
            db_view = db.query(DBViewEntity).filter(DBViewEntity.id == id).first()
            if db_view is None:
                return None
            db.delete(db_view)
            db.commit()
            view = View.from_orm(db_view)
        finally:
            db.close()
        return view

